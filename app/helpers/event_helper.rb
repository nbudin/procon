module EventHelper
  def positioned_staffer(attendance)
    if attendance.staff_position.publish_email
      mail_to attendance.person.email, attendance.person.name, :encode => "javascript"
    else
      attendance.person.name
    end
  end
  
  def positioned_staffers(position)
    with_output_buffer do
      position.attendances.each_with_index do |att, i| 
        output_buffer << positioned_staffer(att)
        output_buffer << ", " unless i == position.attendances.size - 1
      end
    end
  end
end
