source 'https://rubygems.org'

gem 'rails', '~> 4.2.0'
# http://stackoverflow.com/questions/41207432/expected-string-default-value-for-jbuilder-got-true-boolean-error-in-a
gem 'thor', '0.19.1'
gem 'responders', '~> 2.0'

# database
gem 'pg', '~> 0.17.0'

# monitoring
gem 'pghero'
gem 'pg_query'

# configuration
gem 'squire', '~> 1.3.6'

# authentification
# gem 'devise', '~> 3.1.1'
gem 'cancan', '~> 1.6.10'
gem 'net-ldap'

# facebook
gem 'omniauth-facebook'
gem 'fb_graph2', '0.8.0'

# stylesheets
gem 'sass-rails', '~> 4.0.3'
gem 'bootstrap-sass', '~> 3.1.1'
gem 'font-awesome-rails', '~> 4.7.0.1'

# javascripts
gem 'therubyracer', platforms: :ruby
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'uglifier', '>= 1.3.0'
gem 'bootstrap-datepicker-rails', '~> 1.3.0'
gem 'select2-rails', '~> 3.5.10'
gem 'jquery-tablesorter', '~> 1.9.5'
gem 'rails-timeago', '~> 2.0'
gem 'momentjs-rails'
gem 'handlebars_assets'
gem 'jquery-ui-rails'
gem 'd3_rails', '~> 3.4.6'
gem 'cal-heatmap-rails', '~> 0.0.1'

# markdown
gem 'redcarpet'
gem 'pygments.rb'
gem 'gemoji', '~> 1.5.0'
gem 'loofah'

# mailer
gem 'roadie'
gem 'letter_opener', group: :development

# internationalization
gem 'rails-i18n', '~> 4.0.0'
gem 'i18n-js', '~> 2.1.2'

# pagination
gem 'kaminari', '~> 0.15.1'
gem 'kaminari-bootstrap', '~> 3.0.1'

# scheduling
gem 'whenever'

# utilities
gem 'actionview-encoded_mail_to'
gem 'active_model_serializers'
gem 'forgery'
gem 'jbuilder', '~> 1.2'
gem 'murmurhash3'
gem 'nokogiri'
gem 'scout', github: 'smolnar/scout'
gem 'statistics2'
gem 'symbolize'
gem 'lda-ruby'
gem 'tf_idf'
gem 'timecop'
gem 'awesome_nested_set'
gem 'ims-lti', :git => 'https://github.com/instructure/ims-lti.git'
gem 'non-stupid-digest-assets'
gem 'data-anonymization', '~> 0.6.5'

# search
gem 'elasticsearch'

# file upload
gem 'paperclip', '~> 4.3'
gem 'activesupport-json_encoder'
gem 'remotipart', '~> 1.2'

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
  gem 'factory_girl_rails'
  gem 'capybara', '~> 3.1'
  gem 'selenium-webdriver'
  gem 'guard-rspec'

  # database
  gem 'faker', '1.1.2'

  # code metrics
  gem 'simplecov', require: false
  gem 'codeclimate-test-reporter', require: false

  # mass import
  gem 'activerecord-import', '~> 0.10.0'
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
