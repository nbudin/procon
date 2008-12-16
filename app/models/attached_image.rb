class AttachedImage < ActiveRecord::Base
  has_attached_file :image,
    :path => ":rails_root/public/attached_images/:id/:style/:basename.:extension",
    :url => "/attached_images/:id/:style/:basename.:extension"
  belongs_to :site_template
end
