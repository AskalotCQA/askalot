class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    # TODO (zbell) rm
    log action: 'hello'

    @user = User.find_by_login params[:login]
  end
end
