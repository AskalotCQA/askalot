namespace :users do
  desc 'Send notifications to users via email'
  task notifications: :environment do
    Mailers::UserMailerService.deliver_notifications!
  end
end
