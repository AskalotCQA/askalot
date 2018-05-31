module Shared
class AdministrationController < ApplicationController
  before_action :authenticate_user!

  check_authorization
end
end
