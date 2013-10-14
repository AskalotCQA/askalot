module Users
  class Authentication
    attr_accessor :service, :params

    def initialize(service, params)
      @service = service
      @params  = params
    end

    def authorized?
      !!user
    end

    def create_user!
      attributes = {
        login: user.login,
        email: user.email,
        password: @params[:password],
        password_confirmation: @params[:password]
      }

      user = User.new(attributes)

      user.skip_confirmation!
      user.save!
    end

    private

    def user
      @user ||= service.authenticate(params[:login], params[:password])
    end
  end
end
