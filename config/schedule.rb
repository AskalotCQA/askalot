# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

env_name = ENV['RAILS_ENV'].split('_', 2)[0]
env_type = ENV['RAILS_ENV'].split('_', 2)[1]

if env_type != 'staging'
  every 1.day do
    rake 'backup:database'
  end

  every 1.day, at: '4:32am' do
    rake 'reputation:adjust'
  end

  if env_name == 'fiit'
    every 5.minutes do
      rake 'slido:questions'
    end

    every 1.day, at: '5:32am' do
      runner 'University::Mailers::UserMailerService.deliver_notifications!'
    end

    every 10.minutes do
      runner 'Shared::Mailers::CommunityMailerService.deliver_all_emails!'
    end

    every 6.months do
      rake 'users:alumni'
    end
  end

  if env_name == 'edx'
    every 1.day, at: '5:32am' do
      runner 'Mooc::Mailers::UserMailerService.deliver_notifications!'
    end

    every 1.day, at: '00:05am' do
      runner 'recommendation:update_features'
    end

    every 1.day, at: '01:00am' do
      runner 'recommendation:append_expertise_dataset'
      runner 'recommendation:append_willingness_dataset'
      runner 'recommendation:train'
    end

  end
end
