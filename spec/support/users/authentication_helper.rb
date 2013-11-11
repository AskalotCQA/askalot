module Users
  module AuthenticationHelper
    def stub_ais_user(user = nil, options = {})
      user ||= build :user, :as_ais

      data = {
        uisid: [user.ais_uid],
        uid: [user.login],
        cn: [],
        sn: [user.last],
        givenname: [user.first],
        mail: [user.email]
      }

      Stuba::AIS.stub(:authenticate).with(user.login, options[:password] || 'password') do
        Stuba::User.new(data)
      end
    end

    def login_as_ais(user, options = {})
      stub_ais_user(user, options)

      visit new_user_session_path

      fill_in 'user_login', with: user.login
      fill_in 'user_password', with: options[:password] || 'password'

      click_button 'Prihlásiť'

      visit root_path
    end
  end
end
