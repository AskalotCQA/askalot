# Askalot

Askalot is a CQA (Community Question and Answer) system of next generation.

**Latest release**

[![Build Status](https://travis-ci.com/isrba/askalot.svg?token=KiGHuQ2duxZsskaxboZE&branch=master)](https://travis-ci.com/isrba/askalot)  [![Code Climate](https://codeclimate.com/github/AskalotCQA/askalot/badges/gpa.svg)](https://codeclimate.com/github/AskalotCQA/askalot)

**Development**

[![Build Status](https://travis-ci.com/isrba/askalot.svg?token=KiGHuQ2duxZsskaxboZE&branch=gama)](https://travis-ci.com/isrba/askalot)  [![Code Climate](https://codeclimate.com/repos/5710ad164c2a41314500449b/badges/f0124b8f7e331110e733/gpa.svg)](https://codeclimate.com/repos/5710ad164c2a41314500449b/feed)  [![Test Coverage](https://codeclimate.com/repos/5710ad164c2a41314500449b/badges/f0124b8f7e331110e733/coverage.svg)](https://codeclimate.com/repos/5710ad164c2a41314500449b/coverage)

## Requirements

* Ruby 2.3
* Rails 4.1
* PostgreSQL 9.3
* Elasticsearch 1.7

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

There are two types of environments: *university* and *mooc* which are currently implemented as *fiit* and *edx* environments.
You have to use this as suffix to standart development, test, staging, demo and production environment.

Create database, load schema and seed the database.

```
RAILS_ENV=fiit_development rake db:create db:structure:load db:seed
RAILS_ENV=edx_development rake db:create db:structure:load db:seed
```

## Testing

1. Install [PhantomJS](http://phantomjs.org/) (v2.0).
2. Run specs with:

```
RAILS_ENV=fiit_test rake db:create db:structure:load
RAILS_ENV=fiit_test bundle exec rake rspec:test
or
RAILS_ENV=edx_test rake db:create db:structure:load
RAILS_ENV=edx_test bundle exec rake rspec:test
```

Tests will run either *shared+university* or *shared+mooc* tests.

The mapping of environments to the engines is in the `config/environment.yml`.

## Contributing

1. Fork it.
2. Create your feature branch (`git checkout -b new-feature`).
3. Commit your changes (`git commit -am 'Add some feature'`).
4. Push to the branch (`git push origin new-feature`).
5. Create new Pull Request.

## License

This software is released under the [MIT License](LICENSE.md).
