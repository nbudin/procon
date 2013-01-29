source :gemcutter
source "http://gems.github.com"

gem "rails", "2.3.16"
gem "pg"
gem "sqlite3", :groups => [:development, :test]

# bundler requires these gems in all environments
# gem "nokogiri", "1.4.2"
# gem "geokit"

gem 'aaronchi-jrails', '~> 0.5.1', :require => 'jrails'
gem 'paperclip', '~> 2.3'
gem 'aws-s3'
gem 'right_aws'
gem 'febeling-rubyzip', '~> 0.9.2', :require => 'zip/zip'
gem 'ruby-openid', '>= 2.0.4', :require => 'openid'
gem 'ae_users_migrator'
gem 'hoptoad_notifier'
gem 'pry', :groups => [:development, :test]

gem 'devise', '~> 1.0.0'
gem 'rubycas-client', '~> 2.2.0' # 2.3.x breaks in Rails 2 for some reason
gem 'devise_cas_authenticatable'
gem 'cancan'
gem 'illyan_client'

group :development do
  # bundler requires these gems in development
  # gem 'bullet'
end

group :test do
  # bundler requires these gems while running tests
  # gem "rspec"
  # gem "faker"
end

group :production do
  gem "thin"
end
