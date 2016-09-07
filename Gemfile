source 'https://rubygems.org'

ruby '2.3.1'
gem 'rails', '~> 4.2.5'

# Use postgresql as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# Use CoffeeScript for .js.coffee assets and views
# gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 1.2'

  # bundle exec rake doc:rails generates the API under doc/api.

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'devise', '>= 4.2.0'
gem 'foundation-rails', '< 6'
gem 'foundation_rails_helper'
gem 'foundation-icons-sass-rails'
gem 'date_validator'
gem 'haml-rails'

# Gems to include javascript libraries:
gem 'cocoon'
gem 'pickadate-rails'
gem 'select2-rails', '< 4'


group :development do
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'html2haml'
  gem 'hub'
  gem 'rails_layout'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
end

group :test do
  gem 'shoulda-matchers', require: false
  gem 'fabrication'
  gem 'capybara'
  gem 'launchy'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'simplecov'
  gem 'timecop'
  gem 'faker'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'fuubar'
  gem 'thin'
  gem 'pry-rails'
end

group :production do
  gem 'unicorn'
  gem 'rails_12factor' # To enable heroku logging and static assets
end



