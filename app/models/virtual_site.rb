class VirtualSite < ActiveRecord::Base
  belongs_to :event
  validates_associated :event
  
  belongs_to :site_template
end
