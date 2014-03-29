class CategoriesController < ApplicationController
  before_action :authenticate_user!

  include Watchings::Watching

  def index
    @categories = Category.order(:name)
    @tags       = Tag.order(:name)
  end
end
