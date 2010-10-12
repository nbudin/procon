module SchedulesHelper  
  def schedule_header(usetracks)
    colsize = 90.0 / usetracks.size
    if usetracks.size > 1
      content_tag(:table, :class => "scheduleheader") do
        content_tag(:tr) do
          with_output_buffer do
            output_buffer << content_tag(:th, "&nbsp".html_safe, :style => "width: 10%;")
            usetracks.each do |track|
              header_style = "width: #{colsize}%;"
              header_style << " background-color: #{track.color};" if track.color
              
              output_buffer << content_tag(:th, track.name, :style => header_style)
            end
          end
        end
      end
    end
  end
  
  def schedule_body_table(block)
    now = block.start
    lastday = now.day
    interval = block.interval
    
    content_tag(:table, :class => "schedulebody") do
      with_output_buffer do
        rownum = 0
        while now < block.end
          output_buffer << content_tag(:tr, :style => "height: 20px;") do
            border_top_style = if lastday == now.day
              ""
            else
              "border-top: 1px dashed #333;"
            end
            
            content_tag(:td, :style => "width: 10%; border-right: 1px dotted #aaa; #{border_top_style}") do
      			  if lastday == now.day   
                if rownum % 2 == 0
                  now.strftime("%I:%M %p")
                end
              else
                content_tag(:b, now.strftime("%m/%d/%Y"))
              end
            end + content_tag(:td, "&nbsp;".html_safe, :style => "width: 90%; #{border_top_style}")
        	end
          lastday = now.day
        	now += interval
        	rownum += 1
        end
      end
    end
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
    
    content_tag(:div, :style => position_style(position, false), :class => "event #{healthclass}") do
      with_output_buffer do
        output_buffer << content_tag(:b, event.shortname)
        
        if event.kind_of? LimitedCapacityEvent
          output_buffer << "<br/>".html_safe
          output_buffer << health_count(event)
        end
        
        output_buffer << "<br/>".html_safe
        output_buffer << link_to("Who's free\?", 
                          available_people_event_path(event, thickbox_params),
                          :class => 'thickbox', :style => 'font-weight: bold;')
      end
    end
  end
  
  def schedule_event(position)
    event = position.event
    att = person_signed_in? ? current_person.attendance_for_event(event) : nil
    
    position_style = position_style(position)
    position_class = "event"
    position_class << " signedup" if att
    position_class << " waitlist" if att.try(:is_waitlist)
    
    content_tag(:div, :style => position_style, :class => position_class) do
      with_output_buffer do
        output_buffer << link_to(event.shortname, url_for(thickbox_params.update(:controller => 'events', :action => 'show_description', :id => event.id)),
          :class => 'thickbox', :style => 'font-weight: bold;')

        if person_signed_in?
          output_buffer << "<br/><br/>".html_safe
          output_buffer << signup_link(event)
        end
        
        if event.kind_of? LimitedCapacityEvent
          output_buffer << "<br/>".html_safe
          output_buffer << registration_count(event)
        end
        
        if event.locations.size > 0
			    output_buffer << "<br/><br/>".html_safe
			    output_buffer << content_tag(:i, event.locations.collect { |l| l.name }.join(", ") )
        end
      end
    end
  end

  def with_schedule_block(schedule, block, skip_header = false)
    positions = block.event_positions
    
    with_output_buffer do
      output_buffer << content_tag(:h2, block.start.strftime("%A, %B %d, %Y"))
      output_buffer << schedule_header(block.tracks) unless skip_header
      output_buffer << content_tag(:div, :class => "schedule") do 
        with_output_buffer do
          output_buffer << schedule_body_table(block)
          positions.each do |position|
            output_buffer << yield(position)
          end
        end
      end
    end
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
