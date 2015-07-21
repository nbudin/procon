source "https://rubygems.org"

ruby "1.8.7"

gem 'rails', :git => 'https://github.com/makandra/rails.git', :branch => '2-3-lts'
gem "mysql2", "~> 0.2.0"
gem 'pg', '~> 0.17.1'

gem 'jrails', '0.5.1', :github => 'aaronchi/jrails', :branch => 'ea8b56b446f3e55236c25b04eb6c9a10c9a189e6'
gem 'paperclip', '~> 2.3'
gem 'aws-s3'
gem 'right_aws'
gem 'febeling-rubyzip', '~> 0.9.2', :require => 'zip/zip'
gem 'ruby-openid', '>= 2.0.4', :require => 'openid'
gem 'ae_users_migrator'
gem 'exception_notification', :github => 'smartinez87/exception_notification', :branch => '2-3-stable'
gem 'pry', :groups => [:development, :test]
gem 'unicorn'

gem 'devise', '~> 1.0.0'
gem 'rubycas-client', '~> 2.2.0' # 2.3.x breaks in Rails 2 for some reason
gem 'devise_cas_authenticatable'
gem 'cancan'
gem 'json'

gem 'newrelic_rpm'

group :production do
  gem "thin"
end
