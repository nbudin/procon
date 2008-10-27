class SiteTemplate < ActiveRecord::Base
  has_many :virtual_sites
  acts_as_permissioned
end
