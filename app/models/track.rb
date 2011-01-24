class Track < ActiveRecord::Base
  belongs_to :schedule
  has_and_belongs_to_many :events
  acts_as_list :scope => :schedule
end
