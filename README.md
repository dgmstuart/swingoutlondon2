SETUP
=======

Secrets
-------
Create a `secrets.yml` file for the secret key base as per these instructions: http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#config/secrets.yml

Database
--------

* Set up postgres
* `rake db:setup`

Tests
-------

    guard

OR

    bundle exec rspec

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