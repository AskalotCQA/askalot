module Shared
class CategoriesController < ApplicationController
  include Shared::Searchables::Search
  include Shared::Watchables::Watch

  default_tab :all, only: :index
  default_tab :results, only: :search

  before_action :authenticate_user!

  def index
    @category_depths    = CategoryDepth.public_depths
    @context_categories = Shared::Category.in_contexts(@context).includes(:assignments).order('lft')
    category_ids        = Shared::Category.in_contexts(@context).pluck(:id)
    @questions_counts   = Shared::CategoryQuestion.where(category_id: category_ids).group(:category_id).pluck('category_id AS id, count(*) AS count').to_h
    @answers_counts     = Shared::CategoryQuestion.where(category_id: category_ids).joins(question: :answers).group('categories_questions.category_id').pluck('categories_questions.category_id AS id, count(*) AS count').to_h
  end
end
end
