class CategoriesController < ApplicationController
  include Searchables::Search
  include Watchables::Watch

  default_tab :all, only: :index

  before_action :authenticate_user!

  def index
    @categories = Category.order(:name)
    @tags       = Tag.order(:name)
  end
end
