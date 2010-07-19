class Staffer < ActiveRecord::Base
  belongs_to :event
  belongs_to :person
  acts_as_list :scope => :event
end