# Askalot

Askalot is a CQA (Community Question and Answer) system of next generation.

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

## Testing

Run specs with `bundle exec rspec`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin new-feature`)
5. Create new Pull Request

## License

This software is released under the [MIT License](LICENSE.md).
