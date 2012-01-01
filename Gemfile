# Edit this Gemfile to bundle your application's dependencies.
# This preamble is the current preamble for Rails 3 apps; edit as needed.
source 'http://rubygems.org'

gem 'rails', '~> 3.1.0'
gem 'mysql', :groups => :production
gem 'sqlite3', :groups => [:development, :test]

gem "devise"
#gem 'devise_cas_authenticatable', :path => '/Users/nbudin/code/devise_cas_authenticatable'
gem 'devise_cas_authenticatable'
gem 'cancan', '>= 1.1'
gem 'ae_users_migrator'

gem 'ancestry'
gem 'jquery-rails'
gem 'paperclip'
gem 'aws-s3'
gem 'right_aws'
gem 'rubyzip'
gem 'heroku_external_db', '>= 1.0.0'
gem 'airbrake'
gem 'heroku', :groups => :development

group :development do
  # bundler requires these gems in development
  # gem 'bullet'
end

group :test do
  # bundler requires these gems while running tests
  gem "rspec-rails"
  # gem "faker"
end
