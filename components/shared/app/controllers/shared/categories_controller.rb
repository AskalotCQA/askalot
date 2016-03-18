module Shared
class CategoriesController < ApplicationController
  include Shared::Searchables::Search
  include Shared::Watchables::Watch

  default_tab :all, only: :index
  default_tab :results, only: :search

  before_action :authenticate_user!

  def index
    @category_depths  = CategoryDepth.public_depths
    @context_category = Shared::Category.find(@context)
  end
end
end
