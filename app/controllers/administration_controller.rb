class AdministrationController < ApplicationController
  before_action :authenticate_user!
  include Tabbing
  include Editing

  default_tab :changelog, only: :show

  def show
    @categories = Category.order(:name)
  end

  def new_changelog
    @changelog = Changelog.new
  end

end
