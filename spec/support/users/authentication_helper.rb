module Users
  module AuthenticationHelper
    def login_as(user, options = {})
      stub_ais_for(user) if options[:with] == :AIS

      visit new_user_session_path

      stub_ais_for user, options

      visit new_user_session_path

      fill_in 'user_login', with: user.login
      fill_in 'user_password', with: user.password || options[:password] || 'password'

      click_button 'Prihlásiť'

      visit root_path
    end

    def stub_ais_for(user = nil, options = {})
      user ||= build :user, :as_ais

      data = {
        uisid: [user.ais_uid],
        uid: [user.login],
        cn: [],
        sn: [user.last],
        givenname: [user.first],
        mail: [user.email],
        employeetype: [user.role]
      }

      Stuba::AIS.stub(:authenticate).with(user.login, options[:password] || 'password') do
        Stuba::User.new(data)
      end
    end
  end
end
