class AttachedImage < ActiveRecord::Base
  has_attached_file :image
  belongs_to :site_template
end
