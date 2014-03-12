class WatchingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @watchings = Watching.where(watcher: current_user).page(params[:page]).per(20)
  end
end
