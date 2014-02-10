source 'https://rubygems.org'

gem 'rails', '4.0.0'

# database
gem 'pg'

# configuration
gem 'squire', '~> 1.2.6'

# authentification
gem 'devise', '~> 3.1.1'
gem 'cancan', '~> 1.6.9'
gem 'net-ldap'

# stylesheets
gem 'sass-rails', '~> 4.0.0'
gem 'bootstrap-sass', '~> 3.1.0'
gem 'font-awesome-rails', '~> 4.0.3.0'

# javascripts
gem 'therubyracer', platforms: :ruby
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'uglifier', '>= 1.3.0'
gem 'rails-timeago', '~> 2.0'
gem 'select2-rails', '~> 3.4.9'

# internationalization
gem 'rails-i18n', '~> 4.0.0'
gem 'i18n-js'

# pagination
gem 'kaminari',           '~> 0.14.1'
gem 'kaminari-bootstrap', '~> 0.1.3'

# utilities
gem 'actionview-encoded_mail_to'
gem 'forgery'
gem 'jbuilder', '~> 1.2'
gem 'murmurhash3'
gem 'symbolize'
gem 'nokogiri'
gem 'scout', github: 'smolnar/scout', branch: :master

# documentation
group :doc do
  gem 'sdoc', require: false
end

# development
group :development do
  gem 'capistrano', '~> 2.15.5'
  gem 'capistrano-ext'
  gem 'rvm-capistrano'
end

# development & test
group :development, :test do
  # debugging
  gem 'pry'
  gem 'pry-debugger'
  gem 'hirb'

  # testing
  gem 'rspec-rails', '~> 2.0'
  gem 'fuubar'
  gem 'database_cleaner', '~> 1.2.0'
  gem 'factory_girl_rails'
  gem 'launchy'
  gem 'capybara', '~> 2.1.0'
  gem 'selenium-webdriver'
  gem 'capybara-webkit'
  gem 'guard-rspec'

  # database
  gem 'faker', '1.1.2'
end

group :production do
  gem 'unicorn'
  gem 'rack-timeout'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
