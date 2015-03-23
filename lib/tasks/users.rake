namespace :users do
  desc 'Send notifications to users via email'
  task notifications: :environment do
    UserMailerService.deliver_notifications!
  end
end
