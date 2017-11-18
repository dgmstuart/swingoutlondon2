source 'https://rubygems.org'

ruby '2.4.0'
gem 'rails', '< 6'

# Use postgresql as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0', '>= 5.0.6' # https://github.com/rails/sass-rails/issues/381

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# Use jquery as the JavaScript library
gem 'jquery-rails'

gem 'date_validator'
gem 'devise', '>= 4.2.0'
gem 'foundation-icons-sass-rails'
gem 'foundation-rails', '< 6'
gem 'foundation_rails_helper', '< 3'
gem 'haml-rails'

# Gems to include javascript libraries:
gem 'cocoon'
gem 'pickadate-rails'
gem 'select2-rails', '< 4'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'html2haml'
  gem 'hub'
  gem 'rails-erd', require: false
  gem 'rails_layout'
  gem 'rb-fchange', require: false
  gem 'rb-fsevent', require: false
  gem 'rb-inotify', require: false
  gem 'rubocop', require: false
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'fabrication'
  gem 'faker'
  gem 'launchy'
  gem 'poltergeist'
  gem 'shoulda-matchers', require: false
  gem 'simplecov'
  gem 'timecop'
end

group :development, :test do
  gem 'fuubar'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'thin'
end

group :production do
  gem 'rails_12factor' # To enable heroku logging and static assets
  gem 'unicorn'
end
