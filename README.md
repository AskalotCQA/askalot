# Askalot

Askalot is a CQA (Community Question and Answer) system of next generation.

[![Build Status](https://travis-ci.org/teamnaruby/askalot.png)](https://travis-ci.org/teamnaruby/askalot) [![Code Climate](https://codeclimate.com/github/teamnaruby/askalot.png)](https://codeclimate.com/github/teamnaruby/askalot) [![Code coverage](https://codeclimate.com/github/teamnaruby/askalot/coverage.png)](https://codeclimate.com/github/teamnaruby/askalot)

## Requirements

* Ruby 2.1
* Rails 4.1
* PostgreSQL 9.3
* Elasticsearch 1.1

## Installation

Clone and install.

```
git clone git@github.com:teamnaruby/askalot.git
cd askalot
bundle install
```

Copy and edit configuration files.

```
cp config/configuration.{yml.example,yml}
cp config/database.{yml.example,yml}
cp config/newrelic.{yml.example,yml}
```

There are two types of environments: *university* and *mooc*. You have to use this as suffix to standart development, test, staging, demo and production environment.

Create database, load schema and seed the database.

```
RAILS_ENV=development_university rake db:create db:structure:load db:seed
RAILS_ENV=development_mooc rake db:create db:structure:load db:seed
```

## Testing

1. Install [PhantomJS](http://phantomjs.org/) (v2.0).
2. Run specs with:

```
RAILS_ENV=test_university rake db:create db:structure:load
RAILS_ENV=test_university bundle exec rake rspec:test
or
RAILS_ENV=test_mooc rake db:create db:structure:load
RAILS_ENV=test_mooc bundle exec rake rspec:test
```

Tests will run either *shared+university* or *shared+mooc* tests.

## Contributing

1. Fork it.
2. Create your feature branch (`git checkout -b new-feature`).
3. Commit your changes (`git commit -am 'Add some feature'`).
4. Push to the branch (`git push origin new-feature`).
5. Create new Pull Request.

## License

This software is released under the [MIT License](LICENSE.md).
