class PublicInfoValue < ActiveRecord::Base
  belongs_to :public_info_field
  belongs_to :attendance
  
  validates_uniqueness_of :public_info_field_id, :scope => :attendance_id
end
