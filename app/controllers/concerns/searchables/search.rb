module Searchables::Search
  extend ActiveSupport::Concern

  def search(relation, options = {})
    return relation unless search_params[:q].present?
    @model = controller_name.classify.constantize

    relation = @model.search_by(search_params)
  end

  private

  def search_params
    params.permit(:q, :page, :tab)
  end
end


