module Mooc
  class TeacherAdministrationController < ::Shared::ApplicationController
    before_filter :authenticate_user!

    check_authorization
  end
end
