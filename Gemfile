source 'https://rubygems.org'

ruby '2.1.2'
gem 'rails', '4.1.5'

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.17.1'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
# gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails' #, '> 3.1.1' - when it's available

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

gem 'devise', '~> 3.3.0'
gem 'foundation-rails', '~> 5.3.0'
gem 'foundation_rails_helper'
gem 'foundation-icons-sass-rails'
gem 'date_validator', '~> 0.7.0'
gem 'haml-rails', '~> 0.5.3'

# Gems to include javascript libraries:
gem 'cocoon', '~> 1.2.6'
gem 'pickadate-rails', '~> 3.5.3'
gem 'select2-rails', '~> 3.5.9'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec', '~> 4.2', :require=>false
  gem 'html2haml'
  gem 'hub', :require=>nil
  gem 'rails_layout'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
end

group :test do
  gem 'shoulda-matchers', '~> 2.6', require: false
  gem 'fabrication', '~> 2.11.3'
  gem 'capybara', '~> 2.4.1'
  gem 'poltergeist', '~> 1.5.1'
  gem 'database_cleaner', '1.3'
  # gem 'email_spec', '~> 1.5.1' not used yet
  gem 'simplecov', '~> 0.9.0' # Their github says to downgrade, since 0.8 has issues
  gem 'timecop', '~> 0.7.1'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'fuubar'
  gem 'thin'
  gem 'pry', '~> 0.9'
end

group :production do
  gem 'unicorn'
  gem 'rails_12factor' # To enable heroku logging and static assets
end



