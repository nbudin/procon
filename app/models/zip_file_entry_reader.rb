require 'zip/zipfilesystem'
require 'paperclip/upfile'

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