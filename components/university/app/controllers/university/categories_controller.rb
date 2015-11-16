module University
class CategoriesController < ApplicationController
  include University::Searchables::Search
  include University::Watchables::Watch

  default_tab :all, only: :index
  default_tab :results, only: :search

  before_action :authenticate_user!

  def index
    @categories = University::Category.order(:name)
    @tags       = University::Tag.order(:name)
  end
end
end
