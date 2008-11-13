xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0"){
  xml.channel{
    xml.title("Signups for #{@event.fullname}")
    xml.language("en-us")
    xml.link(url_for(params.update({:only_path => false})))
    for attendance in @attendances
      xml.item do
        name = if attendance.person
          attendance.person.name
        else
          "No person"
        end
        xml.title("#{name}#{attendance.status ? " (#{attendance.status})" : ""}")
        xml.description("#{name} signed up for #{@event.fullname} at #{attendance.created_at} with status #{attendance.status}.")
        # rfc822
        if attendance.updated_at
          xml.pubDate(attendance.updated_at.rfc2822)
        end
        xml.link(event_attendance_url(@event, attendance, :only_path => false))
        xml.guid(event_attendance_url(@event, attendance, :only_path => false))
      end
    end
  }
}