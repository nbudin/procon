ca_path = File.join(File.dirname(__FILE__), '..', 'ca')
puts ca_path

if !ActiveRecord::Base.configurations['users'] && ENV['USERS_DATABASE_URL']
  uri = URI.parse(ENV['USERS_DATABASE_URL'])
  db_config = {
    :adapter => uri.scheme,
    :username => uri.user,
    :password => uri.password,
    :database => uri.path[1..-1],
    :host => uri.host
  }

  if ENV['USERS_DATABASE_CA']
    db_config[:sslca] = ENV['USERS_DATABASE_CA']
  end
  ActiveRecord::Base.configurations['users'] = db_config
end

if ENV['DATABASE_CA']
  ActiveRecord::Base.configurations[ENV['RAILS_ENV']][:ssl_ca] = ENV['DATABASE_CA']
end
