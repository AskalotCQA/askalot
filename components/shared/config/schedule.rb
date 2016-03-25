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

every 1.day, at: '5:32am' do
  runner 'Shared::Mailers::UserMailerService.deliver_notifications!'
end

every 10.minutes do
  runner 'Shared::Mailers::CommunityMailerService.deliver_all_emails!'
end

every 1.day do
  rake 'backup:database'
end

every 1.day, at: '4:32am' do
  rake 'reputation:adjust'
end
