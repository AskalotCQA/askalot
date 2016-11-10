require 'data-anonymization'

DataAnon::Utils::Logging.logger.level = Logger::INFO

namespace :dataset do
  desc 'Anonymizes data in current database'
  task anonymize: :environment do
    config = Rails.configuration.database_configuration

    raise ArgumentError.new('You have to specify valid RAILS_ENV.') unless config[Rails.env]

    db_config = Shared::Configuration.anonymized_database

    database 'Database' do
      strategy DataAnon::Strategy::Blacklist

      source_db adapter: db_config[:adapter], database: db_config[:database], pool: db_config[:pool], :username => db_config[:username], :password => db_config[:password]

      table 'events' do
        primary_key 'id'
        batch_size 1000

        anonymize('data') do |field|
          request = field.value['request']

          request.delete('ip')
          request.delete('remote_ip')

          params = field.value['params']
          user   = field.value['user']

          if params
            params.delete('user_id')
            params.delete('oauth_nonce')
            params.delete('resource_link_id')
            params.delete('oauth_signature')
            params.delete('lis_person_sourcedid')
            params.delete('lis_person_contact_email_primary')
          end

          if user
            user.delete('login')
            user.delete('email')
          end

          field.value
        end
      end

      table 'users' do
        primary_key 'id'

        anonymize('login').using        FieldStrategy::RandomUserName.new
        anonymize('email').using        FieldStrategy::GmailTemplate.new('username')
        anonymize('encrypted_password') { |_| 'password' }
        anonymize('ais_uid').using      FieldStrategy::RandomIntegerDelta.new(100000)
        anonymize('ais_login').using    FieldStrategy::RandomUserName.new
        anonymize('nick').using         FieldStrategy::RandomUserName.new

        anonymize('name').using         FieldStrategy::RandomFullName.new
        anonymize('first').using        FieldStrategy::RandomFirstName.new
        anonymize('middle').using       FieldStrategy::RandomFirstName.new
        anonymize('last').using         FieldStrategy::RandomLastName.new
        anonymize('about').using        FieldStrategy::RandomString.new

        anonymize('facebook').using     FieldStrategy::RandomUrl.new
        anonymize('twitter').using      FieldStrategy::RandomUrl.new
        anonymize('linkedin').using     FieldStrategy::RandomUrl.new

        anonymize('confirmation_token')      { |_| nil }
        anonymize('unconfirmed_email').using FieldStrategy::GmailTemplate.new('username')
        anonymize('unlock_token')            { |_| nil }
        anonymize('reset_password_token')    { |_| nil }
        anonymize('current_sign_in_ip')      { |_| '127.0.0.1' }
        anonymize('last_sign_in_ip')         { |_| '127.0.0.1' }

        anonymize('gravatar_email').using FieldStrategy::GmailTemplate.new('username')
        anonymize('bitbucket').using      FieldStrategy::RandomUrl.new
        anonymize('flickr').using         FieldStrategy::RandomUrl.new
        anonymize('foursquare').using     FieldStrategy::RandomUrl.new
        anonymize('github').using         FieldStrategy::RandomUrl.new
        anonymize('google_plus').using    FieldStrategy::RandomUrl.new
        anonymize('instagram').using      FieldStrategy::RandomUrl.new
        anonymize('pinterest').using      FieldStrategy::RandomUrl.new
        anonymize('stack_overflow').using FieldStrategy::RandomUrl.new
        anonymize('tumblr').using         FieldStrategy::RandomUrl.new
        anonymize('youtube').using        FieldStrategy::RandomUrl.new

        anonymize('remember_token') { |_| nil }
        anonymize('omniauth_token') { |_| nil }

        anonymize('facebook_uid').using FieldStrategy::RandomIntegerDelta.new(100000)
        anonymize('facebook_friends')   { |_| nil }
        anonymize('facebook_likes')     { |_| nil }
      end
    end
  end
end
