namespace :users do
  desc 'Send notifications to users via email'
  task notifications: :environment do
    User.joins(:notifications).uniq.find_each do |user|
      UserMailer.notifications(user, from: 1.day.ago).deliver!
    end
  end
end
