class SiteTemplate < ActiveRecord::Base
  has_many :virtual_sites
  has_many :attached_images, :dependent => :destroy
  has_and_belongs_to_many :editors, :class_name => "Person"
  after_save :save_attached_images
  
  def themeroller_css()
    data = read_attribute(:themeroller_css)
    if not data.blank?
      data.gsub!(/url\(images/, "url(attached_images")
    end
    return data
  end
  
  def themeroller_css=(file)
    data = if file.kind_of?(String)
      file
    elsif file.original_filename =~ /.zip$/i
      tf = Tempfile.new(file.original_filename)
      logger.debug "Using tempfile #{tf.path}"
      #copy data into tempfile because rubyzip is braindead about this
      tf.write(file.read)
      tf.flush
      css = ""
      attached_images.clear
      Zip::ZipFile.open(tf.path) do |zipfile|
        zipfile.each do |entry|
          if entry.name =~ /images\/.*(png|gif|jpg|jpeg)$/i
            i = attached_images.new
            img = i.image
            img.assign(ZipFileEntryReader.new(entry, zipfile))
            if not img.valid?
              log.error "[SiteTemplate] Errors with attachment: #{img.errors.join(", ")}"
            end
            i.save!
          elsif entry.name == "jquery-ui-themeroller.css" or entry.name == "ui.all.css"
            css = zipfile.read(entry.name)
          end
        end
      end
      tf.unlink
      css
    else
      file.seek(0, IO::SEEK_SET)
      file.read
    end
    write_attribute(:themeroller_css, data)
  end
  
  private
  def save_attached_images
    attached_images.each do |i|
      i.save
    end
  end
end
