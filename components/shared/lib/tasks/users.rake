namespace :users do
  desc 'Update user alumni flag'
  task alumni: :environment do
    Shared::User.all.each do |u|
      alumni_flag = Shared::Stuba::AIS.alumni? u.ais_login

      u.update_attributes( alumni: alumni_flag) unless u.alumni?.nil? || u.alumni? == alumni_flag

      puts u.alumni?
    end
  end
end
