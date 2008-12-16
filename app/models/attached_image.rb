class AttachedImage < ActiveRecord::Base
  has_attached_file :image,
    :path => ":rails_root/public/attached_images/:id/:style_:filename"
  belongs_to :site_template
end
