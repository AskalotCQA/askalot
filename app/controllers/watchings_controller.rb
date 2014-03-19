class WatchingsController < ApplicationController
  include Tabbing

  default_tab :questions, only: :index

  before_action :authenticate_user!

  def index
    count = 25

    @watchings = Watching.where(watcher: current_user).order(created_at: :desc)

    @questions  = @watchings.of(:question).page(tab_page :questions).per(count)
    @categories = @watchings.of(:category).page(tab_page :categories).per(count)
    @tags       = @watchings.of(:tag).page(tab_page :tags).per(count)
  end
end
