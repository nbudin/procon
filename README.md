# ProCon

_Awesome registration for awesome events_

ProCon is an online event registration system, written for the BSCF LARP Conspiracy’s Festival of the LARPs 2007.  ProCon is written using Ruby on Rails.

# END OF LIFE!

ProCon is offline and no longer supported.  For a modern replacement (which can import ProCon databases), please check out my new app, [Intercode](https://github.com/neinteractiveliterature/intercode)!

## Features

* Easy-to-use online registration.
* Automatic, flexible waitlisting system for events that have limited capacities.
* Events can have child events (for managing conventions, e.g.).
* Ability to create "virtual sites" with their own domain names for particular events.
* Powerful registration policy framework for restricting sign-up.

## Installing ProCon

ProCon is a Rails 2.3 application, so you'll need to have Rails 2.3 installed to use it:

 gem install -v=2.3.2 rails

Once that's installed, you can set up your database configuration in config/database.yml.  For example:

 development:
   adapter: mysql
   host: localhost
   username: root
   database: procon_dev

It uses the ae_users plugin for authentication.  You'll need to either configure a separate users database, or put your user tables in the same database as ProCon uses. 

Either way, you'll need to configure it in config/database.yml:

 users:
   adapter: mysql
   host: localhost
   username: root
   database: procon_dev

Once that's done, you can run the following command to set up your databases:

 rake db:migrate

And you should then be all set to start running ProCon.

## License

ProCon is &copy; [Nat Budin](http://natbudin.com) and is released under the terms and conditions of the [MIT License](http://opensource.org/licenses/MIT).

