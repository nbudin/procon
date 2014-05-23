if ENV['USERS_DATABASE_URL']
  HerokuExternalDb.setup_configuration!("USERS", "users")
end