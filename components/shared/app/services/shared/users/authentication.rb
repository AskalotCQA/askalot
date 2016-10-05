module Shared::Users
  class Authentication
    attr_accessor :service, :factory, :params

    def initialize(service, params)
      @service = service
      @params  = params
    end

    def authorized?
      !!service_user
    end

    def authenticate!
      fail 'Unauthorized access' unless authorized?

      @user ||= factory.where('lower(login) = ?', @params[:login].downcase.strip).first

      create_user! unless @user

      @user.update_attributes!(service_user.to_params.except(:email, :role))

      @user
    end

    def factory
      @factory ||= Shared::User
    end

    private

    def create_user!
      @user = factory.create_without_confirmation!(service_user.to_params)
    end

    def service_user
      @service_user ||= service.authenticate params[:login], params[:password]
    end
  end
end
