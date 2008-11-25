class PublicInfoField < ActiveRecord::Base
  belongs_to :event
  has_many :public_info_values, :dependent => :destroy
  
  def value_for_attendance(attendance)
    public_info_values.find_by_attendance_id(attendance.id)
  end
  
  def value_for_person(person)
    attendance = event.attendances.find_by_person_id(person.id)
    if attendance
      return public_info_values.find_by_attendance_id(attendance.id)
    end
  end
end
