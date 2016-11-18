require 'data-anonymization'
require 'csv'

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

  task export: :environment do
    db_config = Shared::Configuration.anonymized_database
    BATCH_SIZE = 5000

    # Level 3 - Everything, Level 2 - Important stuff
    unless ENV['LEVEL']
      puts 'Using default output level: 2'
      level = 2
    else
      level = ENV['LEVEL']
    end

    FileUtils.mkdir_p 'tmp/export'

    puts 'Export location: tmp/export'

    ActiveRecord::Base.establish_connection(
      adapter: db_config[:adapter],
      database: db_config[:database],
      pool: db_config[:pool],
      username: db_config[:username],
      password: db_config[:password],
    )

    models = [Shared::Activity, Shared::Answer::Profile, Shared::Assignment, Shared::Attachment, Shared::ContextUser,
              Shared::Evaluation, Shared::Following, Shared::Label, Shared::List, Shared::Notification,
              Shared::Question::Profile, Shared::Role, Shared::Tagging, Shared::User::Profile, Shared::View, Shared::Watching]

    models << [Shared::CategoryQuestion, Shared::Changelog, Shared::Email, Shared::Event, Shared::News] if level == 3

    models.flatten!

    models << [Shared::Answer::Revision, Shared::Comment::Revision, Shared::Evaluation::Revision, Shared::Question::Revision, Shared::News] if level >= 2

    models.flatten!

    models << University::Document::Revision if Rails.module.university? && level >= 2
    models << University::Document if Rails.module.university?
    models << University::Group::Revision if Rails.module.university? && level >= 2
    models << University::Group if Rails.module.university?
    models << Shared::SlidoEvent if Rails.module.university? && level >= 2

    models << Mooc::CategoryContent if Rails.module.mooc? && level >= 2

    models.each do |model|
      filename = model.name.downcase.pluralize.sub('shared::', '').sub('::', '_')

      puts "Exporting #{filename}"

      CSV.open("tmp/export/#{filename}.csv", 'wb') do |csv|
        csv << model.attribute_names

        model.find_each(batch_size: BATCH_SIZE).each { |record| csv << record.attributes.values }
      end
    end

    stack_exchange_models = [Shared::Comment, Shared::Favorite, Shared::Labeling, Shared::Answer, Shared::Vote]

    stack_exchange_models.each do |model|
      filename = model.name.downcase.pluralize.sub('shared::', '').sub('::', '_')

      puts "Exporting #{filename}"

      CSV.open("tmp/export/#{filename}.csv", 'wb') do |csv|
        csv << model.attribute_names - ['stack_exchange_uuid']

        Shared::Answer.find_each(batch_size: BATCH_SIZE).each { |record| csv << record.attributes.except('stack_exchange_uuid').values }
      end
    end

    puts 'Exporting categories'

    CSV.open('tmp/export/categories.csv', 'wb') do |csv|
      not_included = ['lft', 'rgt', 'full_tree_name', 'full_public_name', 'askalot_page_url']

      not_included << 'slido_username' if Rails.module.mooc?
      not_included << 'slido_event_prefix' if Rails.module.mooc?
      not_included << 'third_party_hash' if Rails.module.mooc?

      csv << Shared::Category.attribute_names - not_included

      Shared::Category.find_each(batch_size: BATCH_SIZE).each { |e| csv << e.attributes.except(*not_included).values }
    end

    puts 'Exporting questions'

    CSV.open('tmp/export/questions.csv', 'wb') do |csv|
      not_included = ['stack_exchange_uuid', 'stack_exchange_duplicate', 'stack_exchange_questions_uuids']

      not_included << 'slido_question_uuid' if Rails.module.mooc?
      not_included << 'slido_event_uuid' if Rails.module.mooc?

      csv << Shared::Question.attribute_names - not_included

      Shared::Question.find_each(batch_size: BATCH_SIZE).each { |e| csv << e.attributes.except(*not_included).values }
    end

    puts 'Exporting tags'

    CSV.open('tmp/export/tags.csv', 'wb') do |csv|
      not_included = ['stack_exchange_uuid', 'max_time', 'min_votes_difference', 'max_votes_difference']

      csv << Shared::Tag.attribute_names - not_included

      Shared::Tag.find_each(batch_size: BATCH_SIZE).each { |e| csv << e.attributes.except(*not_included).values }
    end

    puts 'Exporting users'

    CSV.open('tmp/export/users.csv', 'wb') do |csv|
      not_included = ['encrypted_password', 'ais_uid', 'ais_login', 'confirmation_token', 'confirmation_sent_at',
                      'unconfirmed_email', 'unlock_token', 'reset_password_token', 'reset_password_sent_at',
                      'remember_created_at', 'stack_exchange_uuid', 'remember_token', 'omniauth_token',
                      'omniauth_token_expires_at']

      not_included << ['facebook_uid', 'facebook_friends', 'facebook_likes', 'alumni'] if Rails.module.mooc?

      not_included.flatten!

      csv << Shared::User.attribute_names - not_included

      Shared::User.find_each(batch_size: BATCH_SIZE).each { |e| csv << e.attributes.except(*not_included).values }
    end

    puts 'Exporting finished'
  end
end
