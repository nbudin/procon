class Person < ActiveRecord::Base
  devise :cas_authenticatable, :trackable
  
  def name
    if nickname
      "#{firstname} \"#{nickname}\" #{lastname}"
    else
      "#{firstname} #{lastname}"
    end
  end
  
  def merge_person_id!(merge_id)
    count = 0
    
    transaction do
      Attendance.where(:person_id => merge_id).each do |att|
        att.person = self
        att.save(false)
        count += 1
      end
    
      Event.where(:proposer_id => merge_id).each do |event|
        event.proposer = self
        event.save(false)
        count += 1
      end
    end
    
    return count
  end
end
