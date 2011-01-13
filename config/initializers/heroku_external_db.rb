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

  db_config[:port] = uri.port unless uri.port.nil?

  if ENV['USERS_DATABASE_CA']
    db_config[:sslca] = File.join(ca_path, ENV['USERS_DATABASE_CA'])
    raise "#{db_config[:sslca]} does not exist!" unless File.exists?(db_config[:sslca])
  end
  ActiveRecord::Base.configurations['users'] = db_config
end

if ENV['DATABASE_CA']
  raise "#{ENV['DATABASE_CA']} does not exist!" unless File.exists?(ENV['DATABASE_CA'])
  ActiveRecord::Base.configurations[ENV['RAILS_ENV']][:ssl_ca] = File.join(ca_path, ENV['DATABASE_CA'])
end