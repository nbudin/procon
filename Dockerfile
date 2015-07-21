FROM octohost/ruby-1.8
MAINTAINER Nat Budin <natbudin@gmail.com>

WORKDIR /app

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install

ADD . /app
RUN mv config/database.yml.production config/database.yml

EXPOSE 3000
CMD ["bundle", "exec", "unicorn_rails", "-p", "3000", "-c", "config/unicorn.rb"]