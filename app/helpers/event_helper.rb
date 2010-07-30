module EventHelper
  def staffer_for_list(staffer)
    with_output_buffer do
      output_buffer << content_tag(:b, "#{staffer.title}: ") unless staffer.title.blank?
        
      if staffer.publish_email?
        output_buffer << mail_to(staffer.person.email, staffer.person.name, :encode => "javascript")
      else
        output_buffer << staffer.person.name
      end
    end
  end
end
