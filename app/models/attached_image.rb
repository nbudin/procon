class AttachedImage < ActiveRecord::Base
  paperclip_config = {
    :path => ":rails_root/public/attached_images/:id/:style/:basename.:extension",
    :url => "/attached_images/:id/:style/:basename.:extension"
  }
  if ENV['S3_BUCKET']
    paperclip_config.update(
      :storage => :s3,
      :s3_credentials => {
        :access_key_id => ENV['S3_KEY'],
        :secret_access_key => ENV['S3_SECRET']
      },
      :bucket => ENV['S3_BUCKET'],
      :path => "attached_images/:id/:style/:basename.:extension"
    )
  end
    
  
  has_attached_file :image, paperclip_config
    
  belongs_to :site_template
end
