source 'https://gems.ruby-china.org'

gem 'sinatra'
gem 'sinatra-contrib', require: false
gem 'activesupport', require: 'active_support/all'
gem 'activerecord', require: 'active_record'
gem 'pg'
# occur error while installing gem kaminari:
#   Your bundle requires gems that depend on each other, creating an infinite loop. Please remove gem 'kaminari' and try again.
# use will_paginate instead
# gem 'kaminari'
gem 'will_paginate', require: %w[will_paginate will_paginate/active_record]

gem 'tilt-jbuilder', require: 'sinatra/jbuilder'
gem 'oj'
gem 'jwt'
gem 'rack-cors', require: 'rack/cors'
gem 'i18n'

gem 'slack-notifier'
# gem 'newrelic_rpm'

group :development do
  gem 'thin'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'byebug'
  gem 'pry'
end

group :test do
  gem 'database_cleaner'
  gem 'faker'
end

group :staging, :production do
  gem 'puma'
end
