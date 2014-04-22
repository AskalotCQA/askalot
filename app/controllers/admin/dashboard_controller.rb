class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  include Editables::Update

  default_tab :changelog, only: :index

  def index
    @categories = Category.order(:name)
    @category = Category.new
    @changelog = Changelog.new
  end

end
