namespace :users do

  desc 'Update user alumni flag'
  task alumni: :environment do
    User.all.each do |u|
      alumni_flag = Stuba::AIS.alumni u.ais_login

      u.update_attributes( alumni: alumni_flag) if !u.alumni.nil? && u.alumni != alumni_flag

      puts u.alumni
    end
  end
end
