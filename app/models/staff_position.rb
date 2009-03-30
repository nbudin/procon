class StaffPosition < ActiveRecord::Base
  belongs_to :event
  acts_as_list :scope => :event
  has_many :attendances
end
