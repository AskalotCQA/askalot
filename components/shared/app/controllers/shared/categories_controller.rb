module Shared
class CategoriesController < ApplicationController
  include Shared::Searchables::Search
  include Shared::Watchables::Watch

  default_tab :all, only: :index
  default_tab :results, only: :search

  before_action :authenticate_user!

  def index
    @context_categories = Shared::Category.in_contexts(@context_id).not_unknown.includes(:assignments, :watchers).order('full_tree_name')
    category_ids        = Shared::Category.in_contexts(@context_id).not_unknown.pluck(:id)
    @questions_counts   = Shared::CategoryQuestion.where(category_id: category_ids).group(:category_id).pluck('category_id AS id, count(*) AS count').to_h
    @answers_counts     = Shared::CategoryQuestion.where(category_id: category_ids).joins(question: :answers).group('categories_questions.category_id').pluck('categories_questions.category_id AS id, count(*) AS count').to_h
  end
end
end
