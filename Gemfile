source 'https://rubygems.org'

ruby '2.3.1'
gem 'rails', '~> 5.0'

# Use postgresql as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0', '>= 5.0.6' # https://github.com/rails/sass-rails/issues/381

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# Use jquery as the JavaScript library
gem 'jquery-rails'

gem 'devise', '>= 4.2.0'
gem 'foundation-rails', '< 6'
gem 'foundation_rails_helper', '< 3'
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



