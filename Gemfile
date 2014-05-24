source "https://rubygems.org"

ruby "1.8.7"

gem 'rails', :git => 'https://github.com/makandra/rails.git', :branch => '2-3-lts'
gem "mysql2", "~> 0.2.0"

# bundler requires these gems in all environments
# gem "nokogiri", "1.4.2"
# gem "geokit"

gem 'jrails', '0.5.1', :github => 'aaronchi/jrails', :branch => 'ea8b56b446f3e55236c25b04eb6c9a10c9a189e6'
gem 'paperclip', '~> 2.3'
gem 'aws-s3'
gem 'right_aws'
gem 'febeling-rubyzip', '~> 0.9.2', :require => 'zip/zip'
gem 'ruby-openid', '>= 2.0.4', :require => 'openid'
gem 'ae_users_migrator'
gem 'heroku_external_db', '>= 1.0.0'
gem 'airbrake'
gem 'pry', :groups => [:development, :test]
gem 'unicorn'

gem 'devise', '~> 1.0.0'
gem 'rubycas-client', '~> 2.2.0' # 2.3.x breaks in Rails 2 for some reason
gem 'devise_cas_authenticatable'
gem 'cancan'
gem 'json'

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
