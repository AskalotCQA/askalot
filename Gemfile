source 'https://rubygems.org'

gem 'rails', '~> 4.2.0'
gem 'responders', '~> 2.0'

# database
gem 'pg', '~> 0.17.0'

# monitoring
gem 'pghero'
gem 'pg_query'

# configuration
gem 'squire', '~> 1.3.6'

# authentification
gem 'cancancan', '~> 2.1.0'
gem 'net-ldap'

# facebook
gem 'omniauth-facebook'
gem 'fb_graph2', '0.8.0'    # must be fixed to v0.8.0, notifications are accidentally removed in next version

# stylesheets
# sass gem must be fixed to this particular version due to a bug described in https://github.com/sass/sass/issues/2214
gem 'sass', '3.4.22'
gem 'sass-rails', '~> 5.0.0'
gem 'bootstrap-sass', '~> 3.1.1'
gem 'font-awesome-rails', '~> 4.7.0.1'

# javascripts
gem 'therubyracer', platforms: :ruby
gem 'coffee-rails', '~> 4.2.0'
gem 'jquery-rails'
gem 'uglifier', '>= 1.3.0'
gem 'bootstrap-datepicker-rails', '~> 1.8.0'
gem 'select2-rails', '~> 3.5.10'
gem 'jquery-tablesorter', '~> 1.25.2'
gem 'rails-timeago', '~> 2.16'
gem 'momentjs-rails'
gem 'handlebars_assets'
gem 'jquery-ui-rails'
gem 'd3_rails', '~> 3.5.11'
gem 'cal-heatmap-rails', '~> 3.6.0'
gem 'icheck-rails'

# markdown
gem 'redcarpet'
gem 'pygments.rb'
gem 'gemoji', '~> 1.5.0'
gem 'loofah'

# mailer
gem 'roadie-rails'
gem 'letter_opener', group: :development

# internationalization
gem 'rails-i18n', github: 'svenfuchs/rails-i18n', branch: 'rails-4-x' # For 4.x
gem 'i18n-js', '~> 3.0.7'

# pagination
gem 'kaminari', '~> 1.1.0'
gem 'kaminari-bootstrap', '~> 3.0.1'

# scheduling
gem 'whenever'

# utilities
gem 'actionview-encoded_mail_to'
gem 'active_model_serializers'
gem 'forgery'
gem 'murmurhash3'
gem 'nokogiri'
gem 'scout', github: 'smolnar/scout'
gem 'statistics2'
gem 'symbolize'
gem 'lda-ruby'
gem 'tf_idf'
gem 'timecop'
gem 'awesome_nested_set'
gem 'ims-lti', '~> 1.2.0'
gem 'non-stupid-digest-assets'
gem 'data-anonymization', '~> 0.6.5'
gem 'meta_request', group: :development

# search
gem 'elasticsearch'

# file upload
gem 'paperclip', '~> 6.0'
gem 'activesupport-json_encoder'
gem 'remotipart', '~> 1.4'

group :doc do
  gem 'sdoc', require: false
end

group :development do
  gem 'capistrano', '~> 2.15.5'
  gem 'capistrano-ext'
  gem 'rvm-capistrano', require: false
  gem 'bump', github: 'pavolzbell/bump'
  gem 'web-console'
  gem 'bullet'
end

group :development, :test do
  # debugging
  gem 'pry-byebug'
  gem 'hirb'

  # testing
  gem 'rspec-rails', '~> 3.6'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'capybara', '~> 3.1'
  gem 'capybara-selenium'
  gem 'chromedriver-helper'
  gem 'guard-rspec'

  # database
  gem 'faker', '1.8.0'

  # code metrics
  gem 'simplecov', require: false

  # mass import
  gem 'activerecord-import', '~> 0.23.0'
end

group :demo, :staging, :production, :experimental do
  gem 'unicorn'
  gem 'rack-timeout'
  gem 'exception_notification'

  # monitoring
  gem 'garelic'
  gem 'newrelic_rpm'
end

gem 'shared', path: 'components/shared'

group :university do
  gem 'university', path: 'components/university'
end

group :mooc do
  gem 'mooc', path: 'components/mooc'
end
