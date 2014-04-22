class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  include Tabbing
  include Editing

  default_tab :changelog, only: :index

  def index
    @categories = Category.order(:name)
    @category = Category.new
    @changelog = Changelog.new
  end

end
