# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'aaronchi-jrails', :lib => 'jrails', :source => "http://gems.github.com", :version => "~> 0.5.1"
  config.gem 'thoughtbot-paperclip', :lib => 'paperclip', :source => "http://gems.github.com", :version => "~> 2.3.1"
  config.gem 'febeling-rubyzip', :lib => 'zip/zip', :source => "http://gems.github.com", :version => "~> 0.9.2"
  
  config.action_controller.session = { :session_key => '_procon_session',
    :secret => 'bc255802f9d9bc085a354679499f23c59bd5c4750ad7c12e3ddb2b1b1ce65092ad081667da7c798f01fc00e981535f28efa7cef737ec068bffde7598773a663f'
    }
end

AeUsers.profile_class = ProconProfile
AeUsers.js_framework = "jquery"
