if(Rails.env.production?)
  ActionMailer::Base.smtp_settings = {
    :address => "smtp.mandrillapp.com",
    :port => 587,
    :user_name => ENV["MANDRILL_USERNAME"],
    :password => ENV["MANDRILL_PASSWORD"],
    :authentication => "login",
    :domain => "heroku.com"
  }
  ActionMailer::Base.delivery_method = :smtp
end