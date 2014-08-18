SETUP
=======

Secrets
-------
Create a `secrets.yml` file for the following items as per these instructions: http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#config/secrets.yml

  * `secret_key_base` - generate with `rake secret`
  * `devise_secret_key` - generate with `rake secret`

If deploying to heroku run the following to set up the secret keys on production:

    heroku config:set SECRET_KEY_BASE=`rake secret`
    heroku config:set DEVISE_SECRET_KEY=`rake secret`

Database
--------

* Set up postgres
* `rake db:setup`

Tests
-------
### Phantomjs
The acceptance specs which require javascript run using phantomjs. To install this on OSX:

    brew install phantomjs


### Running
    guard

OR

    bundle exec rspec

Note that javascript acceptance tests (tagged with :js) are not run in Guard. To run these individually:

    rspec --tag js

Contributing
------------

The usual drill: fork, pull request. If your code doesn't come with tests or breaks the existing test suite it won't be accepted.


TODO:
-----

* Ruby version

* System dependencies

* Configuration

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions