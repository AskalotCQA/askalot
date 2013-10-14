module Users
  class Authentication
    attr_accessor :service, :session, :params

    def initialize(service, session, params)
      @service = service
      @session = session
      @params  = params
    end

    def valid?
      !!user
    end

    def create_user!
      attributes = {
        login: user.login,
        email: user.email,
        password: user.password,
        password_confirmation: user.password
      }

      User.new_with_session(attributes, @session).save!
    end

    private

    def user
      @user ||= service.authenticate(params[:login], params[:password])
    end
  end
end
