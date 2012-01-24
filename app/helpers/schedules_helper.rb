module SchedulesHelper  
  def schedule_header(usetracks)
    colsize = 90.0 / usetracks.size
    output = ""
    if usetracks.size > 1
      output << "<table class=\"scheduleheader\">\n"
      output << "  <tr>\n"
      output << "    <th style=\"width: 10%;\"></th>\n"
      usetracks.each do |track|
        output << "    <th style=\"width: #{colsize}%;"
        if track.color
          output += " background-color: #{track.color};"
        end
        output << "\">\n"
        output << h(track.name)
        output << "    </th>\n"
      end
      output << "  </tr>\n"
      output << "</table>"
    end
    return output
  end
  
  def schedule_body_table(block)
    now = block.start
    lastday = now.day
    interval = block.interval
    output = "<table class=\"schedulebody\">\n"
    rownum = 0
    while now < block.end
      output << "  <tr style=\"height: 20px;\">\n"
      output << "    <td style=\"width: 10%; border-right: 1px dotted #aaa;"
      if lastday != now.day
        output << " border-top: 1px dashed #333;"
      end
      output << "\">\n"
			if lastday == now.day   
        if rownum % 2 == 0
          output << "      #{now.strftime("%I:%M %p")}\n"
        end
      else
        output << "      <b>#{now.strftime("%m/%d/%Y")}</b>\n"
      end        
			output << "    </td>\n"
			output << "    <td style=\"width: 90%;"
      if lastday != now.day
        output << " border-top: 1px dashed #333;"
      end
      output << "\">&nbsp;</td>\n"
    	output << "  </tr>\n"
      lastday = now.day
    	now += interval
    	rownum += 1
    end
    output << "</table>"
    return output
  end
  
  def position_style(position, background_color = true)
    position_style = ""
    %w{left top width height}.each do |attr|
      position_style << " #{attr}: #{position.send(attr)}%;"
    end
    position_style << "background-color: #{position.color}" if background_color
    
    return position_style
  end

  def health_event(position, healthclass)
    event = position.event
    output = <<-ENDHTML
      <div style="#{position_style(position, false)}"
           class="event #{healthclass}">
        <b>#{h event.shortname}</b>
    ENDHTML
    if event.kind_of? LimitedCapacityEvent
      output << "<br/>\n"
      output << health_count(event)
    end

    output << "<br/>\n"
    output << link_to("Who's free\?", 
                      url_for(:controller => 'events', :action => 'available_people', :id => event.id) + thickbox_params, 
                      :class => 'thickbox', :style => 'font-weight: bold;')

    output << "</div>\n"
    return output
  end
  
  def schedule_event(position)
    event = position.event
    att = logged_in? ? logged_in_person.app_profile.attendance_for_event(event) : nil
    
    position_class = "event"
    position_class << " signedup" if att
    position_class << " waitlist" if att.try(:is_waitlist)
    
    output = <<-ENDHTML
<div style="#{position_style(position, true)}" class="#{position_class}">
  #{ link_to event.shortname, url_for(:controller => 'events', :action => 'show_description', :id => event.id) + thickbox_params, 
    :class => 'thickbox', :style => 'font-weight: bold;' }
ENDHTML
    if logged_in?
      output << "<br/><br/>\n"
      output << signup_link(event, true)
    elsif event.registration_open
      output << "<br/><br/>\n"
      output << "To sign up, please #{ link_to "log in", :controller => "auth", :action => "login" }."
    end
    if event.kind_of? LimitedCapacityEvent
      output << "<br/>\n"
      output << registration_count(event)
    end
    if event.locations.size > 0
			output << "<br/><br/>\n"
			output << "<i>"
			output << event.locations.collect { |l| h(l.name) }.join(", ")
			output << "</i>\n"
    end
    output << "</div>\n"

    return output
  end

  def with_schedule_block(schedule, block, skip_header = false)
    positions = block.event_positions
    
    output = "<h2>#{ block.start.strftime("%A, %B %d, %Y") }</h2>\n\n"
    unless skip_header
      output << schedule_header(block.tracks)
    end
    output << "\n\n<div class=\"schedule\">\n"
    output << schedule_body_table(block)
    positions.each do |position|
      output << yield(position)
    end
    output << "</div>"
    return output
  end
  
  def schedule_block(schedule, block)
    with_schedule_block(schedule, block) do |position|
      schedule_event(position)
    end
  end

  def health_class(event)
    if event.kind_of? LimitedCapacityEvent
      if event.full?
        "health_full"
      elsif event.at_preferred?
        "health_at_preferred"
      elsif event.at_min?
        "health_at_min"
      else
        "health_below_min"
      end
    else
      "health_na"
    end
  end

  def health_block(schedule, block)
    with_schedule_block(schedule, block, true) do |position|
      health_event(position, health_class(position.event))
    end
  end
end
