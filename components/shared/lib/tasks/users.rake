namespace :users do
  desc 'Update user alumni flag'
  task alumni: :environment do
    Shared::User.all.each do |u|
      next unless u.encrypted_password.empty?

      alumni_flag = Shared::Stuba::AIS.alumni? u.ais_login

      u.update_attributes( alumni: alumni_flag) unless u.alumni?.nil? || u.alumni? == alumni_flag
    end
  end
end
