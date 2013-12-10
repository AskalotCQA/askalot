class StatisticsController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize! :observe, nil

    @users = User.order(:name).all
  end
end
