ca_path = File.join(File.dirname(__FILE__), '..', 'ca')

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
    db_config[:sslca] = File.join(ca_path, ENV['USERS_DATABASE_CA'])
  end
  ActiveRecord::Base.configurations['users'] = db_config
end

if ENV['DATABASE_CA']
  ActiveRecord::Base.configurations[ENV['RAILS_ENV']][:ssl_ca] = File.join(ca_path, ENV['DATABASE_CA'])
end
