class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  include Editables::Update

  default_tab :changelog, only: :index

  def index
    @changelogs = Changelog.order(version: :desc)
    @categories = Category.order(:name)
    @category = Category.new
    @changelog = Changelog.new
  end

end
