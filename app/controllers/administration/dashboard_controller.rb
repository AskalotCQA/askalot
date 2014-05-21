class Administration::DashboardController < ApplicationController
  before_action :authenticate_user!

  default_tab :categories, only: :index

  def index
    authorize! :administrate, nil

    @categories = Category.order(:name)
    @changelogs = Changelog.all.sort

    @category  = Category.new
    @changelog = Changelog.new
  end
end
