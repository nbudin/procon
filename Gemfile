# Edit this Gemfile to bundle your application's dependencies.
# This preamble is the current preamble for Rails 3 apps; edit as needed.
source 'http://rubygems.org'

gem 'rails', '3.0.0.beta4'
gem 'mysql'

gem "devise", "1.1.rc1"
gem 'devise_cas_authenticatable', :path => '/Users/nbudin/code/devise_cas_authenticatable'
#gem 'devise_cas_authenticatable', :git => "git://github.com/nbudin/devise_cas_authenticatable", :branch => "devise1.1"
gem 'cancan', '>= 1.1'

gem 'json_pure'
gem 'ae_users_migrator', :path => '/Users/nbudin/code/ae_users_migrator'

gem 'jrails', '~> 0.6.0'
gem 'paperclip', '~> 2.3.3'
gem 'rubyzip', :require => 'zip/zip'

# Bundle gems for certain environments:
# gem 'rspec', :group => :test
group :test do
  gem 'factory_girl_rails'
  gem 'shoulda', '>= 2.10.3'
  gem 'capybara'
  gem 'cucumber-rails'
  gem 'launchy'
end