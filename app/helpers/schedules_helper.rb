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
			if rownum % 2 == 0
        fstr = "%I:%M %p"   
        if lastday != now.day
          fstr << " %m/%d/%Y"
        end
        output << "      #{now.strftime(fstr)}\n"
			end
			output << "    </td>\n"
			output << "    <td style=\"width: 90%;\">&nbsp;</td>\n"
    	output << "  </tr>\n"
      lastday = now.day
    	now += interval
    	rownum += 1
    end
    output << "</table>"
    return output
  end
  
  def schedule_event(position)
    event = position.event
    att = logged_in? ? logged_in_person.app_profile.attendance_for_event(event) : nil
    output = <<-ENDHTML
<div style="left: #{position.left}%;
            width: #{position.width}%;
            top: #{position.top}%;
            height: #{position.height}%;
            background-color: #{ position.color };"
     class="event #{ att ? 'signedup' : '' } #{ att and att.is_waitlist ? 'waitlist' : '' }">
  #{ link_to event.shortname, url_for(:controller => 'events', :action => 'show_description', :id => event.id) + thickbox_params, 
    :class => 'thickbox', :style => 'font-weight: bold;' }
ENDHTML
    if logged_in?
      output << "<br/><br/>\n"
      output << signup_link(event)
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
  
  def schedule_block(schedule, block)
    positions = block.obtain_event_positions
    
    output = "<h2>#{ block.start.strftime("%A, %B %d, %Y") }</h2>\n\n"
    output << schedule_header(block.obtain_tracks)
    output << "\n\n<div class=\"schedule\">\n"
    output << schedule_body_table(block)
    positions.each do |position|
      output << schedule_event(position)
    end
    output << "</div>"
    return output
  end
end
