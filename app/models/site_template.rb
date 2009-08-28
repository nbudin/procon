gem 'rubyzip'
require 'zip/zipfilesystem'

class ZipFileEntryReader
  include Paperclip::Upfile
  
  def initialize(entry, zipfile)
    @entry = entry
    @zipfile = zipfile
  end
  
  def path
    @entry.name
  end
  
  def basename
    File.basename(self.path)
  end
  
  def read
    @zipfile.read(self.path)
  end
  
  def size
    @entry.size
  end
  
  def to_tempfile
    tf = Tempfile.new(self.basename)
    tf.write(self.read)
    tf.flush
    return tf
  end
end

class SiteTemplate < ActiveRecord::Base
  has_many :virtual_sites
  has_many :attached_images, :dependent => :destroy
  acts_as_permissioned
  
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
            i = attached_images.create
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
end
