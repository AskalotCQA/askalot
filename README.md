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

Create database.

```
RAILS_ENV=development rake db:create
```

Seed the database.

```
RAILS_ENV=development rake db:seed
```

## Testing

1. Install [PhantomJS](http://phantomjs.org/) (v2.0).
2. Run specs with `bundle exec rspec`.

## Contributing

1. Fork it.
2. Create your feature branch (`git checkout -b new-feature`).
3. Commit your changes (`git commit -am 'Add some feature'`).
4. Push to the branch (`git push origin new-feature`).
5. Create new Pull Request.

## License

This software is released under the [MIT License](LICENSE.md).
