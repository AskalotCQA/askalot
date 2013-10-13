class UsersController < ApplicationController
  def show
    @user = User.find_by_login(params[:login])

    authorize! :read, @user
  end
end
