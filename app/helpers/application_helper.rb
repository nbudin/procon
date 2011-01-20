# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def event_length(e)
    return "(Unscheduled)" if e.length.nil?

    if e.length / 60 / 60 < 12
      return distance_of_time_in_words(e.start, e.end)
    end
      
    # count midnights, rule of thumb is "x days" where x = midnights + 1
    
    if e.start.at_beginning_of_day == e.end.at_beginning_of_day
      midnights = 0
    else
      midnights = (e.end.at_beginning_of_day - e.start.at_beginning_of_day) / 60 / 60 / 24
    end
    
    days = midnights + 1
    return "#{pluralize days.round, "days"}"
  end
  
  def event_locations(event)
    locs = Location.roots(event.locations)
    return h(locs.collect { |l| l.name }.join(", "))
  end

  def jqid(id)
    escid = id.gsub(/(\W)/, "\\\\\\\\\\1")
    return "'##{escid}'"
  end

  def instance_id(object_name, method)
    "#{object_name}_#{method}".gsub(/\W/, "_").gsub(/_+/, "_").sub(/_+$/, "")
  end

  def constrained_date_select(object_name, method, start_time, end_time, options = {}, html_options = {})
    options = options.dup

    html = ""
    if start_time and end_time
      options[:default] ||= start_time
      cur = start_time.beginning_of_day
      date_options = []
      default = nil
      while cur <= end_time do
        date_options.push([ cur.strftime("%A, %b %d"), cur.to_i ])
        if options[:default] >= cur and options[:default] < (cur + 1.day)
          default = cur.to_i
        end
        cur += 1.day
      end
      shim_id = instance_id("date_shim_#{object_name}", method)
      html << select_tag(shim_id, options_for_select(date_options, default), html_options)
      html << <<-ENDOFHTML
<script type="text/javascript">
$(function() {
  $('##{shim_id}').eventDateShim("#{instance_id(object_name, method)}");
});
</script>
ENDOFHTML
      html << hidden_field_tag("#{object_name}[#{method}(1i)]", options[:default].year, :id => instance_id(object_name, "#{method}(1i)"))
      html << hidden_field_tag("#{object_name}[#{method}(2i)]", options[:default].month, :id => instance_id(object_name, "#{method}(2i)"))
      html << hidden_field_tag("#{object_name}[#{method}(3i)]", options[:default].day, :id => instance_id(object_name, "#{method}(3i)"))
    else
      html << content_tag(:span, html_options) do 
        date_select(object_name, method, options)
      end
    end
  end

  def event_date_select(event, method, options = {}, html_options = {})
    start_time = event.parent ? event.parent.start : nil
    end_time = event.parent ? event.parent.end : nil
    return constrained_date_select("event[#{event.id}]", method, start_time, end_time, 
                                   options.update(:default => event.send(method)), html_options)
  end

  def time_options(options, default)
    options_for_select(options.collect {|o| sprintf("%02d", o) }, sprintf("%02d", default))
  end

  def constrained_time_select(object_name, method, start_time, end_time, options = {}, html_options = {})
    default = options[:default] || Time.new
    html = select_tag("#{object_name}[#{method}(4i)]", time_options(0..23, default.hour), html_options)
    html << " : "
    html << select_tag("#{object_name}[#{method}(5i)]", time_options(%w{00 15 30 45}, default.min), html_options)
    return html
  end

  def event_time_select(event, method, options = {}, html_options = {})
    return constrained_time_select("event[#{event.id}]", method, event.start, event.end,
                                   options.update(:default => event.send(method)), html_options)
  end

  def event_datetime_select(event, method, options = {}, html_options = {})
    html = event_date_select(event, method, options, html_options)
    html << " at "
    html << event_time_select(event, method, options, html_options)
    return html
  end

  def constrained_datetime_select(object_name, method, start_time, end_time, options = {}, html_options = {})
    html = constrained_date_select(object_name, method, start_time, end_time, options, html_options)
    html << " at "
    html << constrained_time_select(object_name, method, start_time, end_time, options, html_options)
    return html
  end
  
  def signup_url(event)
    if logged_in?
      url_for :controller => :signup, :action => :signup, :event => event
    else
      url_for :controller => :signup, :action => :form, :event => event
    end
  end
  
  def thickbox_params
    '?site_template=none&TB_iframe=true&KeepThis=true&height=400&width=500'
  end
  
  def signup_link(event)
    if not logged_in?
      return ''
    end
    att = logged_in_person.app_profile.attendance_for_event(event)
    output = ""
    if att.nil?
      if event.registration_open
        caption = if not (event.kind_of?(LimitedCapacityEvent) and event.full_for_gender?(logged_in_person.gender))
          "Sign up"
        else
          "Waitlist"
        end
        output += "[#{ link_to caption, signup_url(event) + thickbox_params + '&modal=true', :class => 'thickbox' }]"
      end
    else
      link_caption = "Drop out"
      
      if att.is_staff
        confirm_msg = "WARNING: You are a staff member for this event!  Dropping this event will "
        confirm_msg += "cause you to lose your edit privileges for the event.  Are you sure you "
        confirm_msg += "want to proceed?"
      elsif att.is_waitlist
        confirm_msg = "Are you sure you want to drop off the waitlist for this event?  If you do so, "
        confirm_msg += "you will lose your place in line."
        link_caption = "Drop from waitlist"
      else
        confirm_msg = "Are you sure you want to drop out of #{event.shortname}?"
      end
      output += "[#{ link_to link_caption, url_for(:controller => 'signup', :action => 'dropout', :event => event),
                      :confirm => confirm_msg}]"
    end
    return output
  end
  
  def page_title
    if @context
      @context.fullname
    elsif @virtual_site and not @virtual_site.name.blank?
      @virtual_site.name
    else
      "ProCon"
    end
  end
  
  def location_options(selected, parent=nil, indent_level = 0)
    parent_id = parent ? parent.id : nil
    Location.find_all_by_parent_id(parent_id, :order => "name").collect do |loc|
      html = "<option value=\"#{loc.id}\""
      if selected.include?(loc)
        html += " selected=\"selected\""
      end
      html += ">"
      html += "&nbsp;&nbsp;" * indent_level
      html += h(loc.name)
      html += "</option>"
      html + location_options(selected, loc, indent_level + 1)
    end.join("\n")
  end
  
  def open_slot_count(event)
    if event.gendered?
      slots = []
      maxmale = event.max_count("male")
      maxfemale = event.max_count("female")
      maxneutral = event.max_count("neutral")
      if maxmale > 0
        slots.push "#{event.open_slots "male"}/#{maxmale} M"
      end
      if maxfemale > 0
        slots.push "#{event.open_slots "female"}/#{maxfemale} F"
      end
      if maxneutral > 0
        slots.push "#{event.open_slots "neutral"}/#{maxneutral} N"
      end
      return slots.join(", ")
    else
      return "#{event.open_slots}/#{event.max_count}"
    end
  end
  
  def waitlist_count(event)
    slots = []
    if event.gendered?
      wlmale = event.waitlist_count("male")
      wlfemale = event.waitlist_count("female")
      if wlmale > 0
        slots.push "#{wlmale} M"
      end
      if wlfemale > 0
        slots.push "#{wlfemale} F"
      end
    else
      slots.push "#{event.waitlist_count}"
    end
    if slots.size == 0
      return "Full, no waitlist"
    else
      wlnumber = nil
      if logged_in?
        wlnumber = event.waitlist_number(logged_in_person)
      end
      if wlnumber
        return "You are \##{wlnumber} in the waitlist"
      else
        return "Waitlist: " + slots.join(", ")
      end
    end
  end
  
  def registration_count(event)
    if event.full?
      return waitlist_count(event)
    else
      return "Available: " + open_slot_count(event)
    end
  end

  def signup_count(event, show_blank_agenda_count=false)
    if event.kind_of? LimitedCapacityEvent and event.gendered?
		  html = pluralize(event.attendee_count, "attendee")
      html << " total: "
      html << event.attendee_count("male").to_s
      html << " male,"
      html << event.attendee_count("female").to_s
      html << " female"
	  else
	  	html = pluralize(event.attendee_count, "attendee")
	  end

    if show_blank_agenda_count and event.children.count > 0
      html << " ("
      html << event.attendees_with_blank_agenda.count.to_s
      html << " of which not signed up for any child event)"
    end

    return html
  end

  def threshold_needed(event, threshold)
    slot_count = {}
    ["male", "female", "neutral"].each do |gender|
      slot_count[gender] = event.slot_count(gender, threshold)
    end

    male_needed = slot_count["male"] - event.attendee_count("male")
    female_needed = slot_count["female"] - event.attendee_count("female")
    neutral_needed = slot_count["neutral"]

    if male_needed < 0
      neutral_needed += male_needed
      male_needed = 0
    end

    if female_needed < 0
      neutral_needed += female_needed
      female_needed = 0
    end

    return {"male" => male_needed, "female" => female_needed, "neutral" => neutral_needed}
  end

  def threshold_count(event, threshold)
    tn = threshold_needed(event, threshold)
    if tn["male"] > 0 or tn["female"] > 0
      "#{tn["male"]}M, #{tn["female"]}F, #{tn["neutral"]}N needed for #{threshold}"
    else
      "#{tn["neutral"]} needed for #{threshold}"
    end
  end

  def health_count(event)
    if event.full?
      return waitlist_count(event)
    else
      next_threshold = if event.at_preferred?
        "max"
      elsif event.at_min?
        "preferred"
      else
        "min"
      end

      threshold_count(event, next_threshold)
    end
  end
  
  def logged_in_person_can_edit?(event=nil)
    p = logged_in_person
    if p.nil?
      return false
    else
      if event
        return event.has_edit_permissions?(p)
      else
        return p.permitted?(nil, "edit_events")
      end
    end
  end
  
  def global_admin?
    logged_in_person_can_edit?(nil)
  end
end
