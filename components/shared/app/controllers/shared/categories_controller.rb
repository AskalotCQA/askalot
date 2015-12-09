module Shared
class CategoriesController < ApplicationController
  include Shared::Searchables::Search
  include Shared::Watchables::Watch

  default_tab :all, only: :index
  default_tab :results, only: :search

  before_action :authenticate_user!

  def index
    @categories = Shared::Category.groups_in_context(Shared::Tag.current_academic_year_value)
    @tags       = Shared::Tag.order(:name)
  end
end
end
