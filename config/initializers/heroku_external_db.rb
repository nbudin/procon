if ENV['EXTERNAL_DATABASE_URL']
  HerokuExternalDb.setup_rails_env!
end
