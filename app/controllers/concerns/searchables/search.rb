module Searchables::Search
  extend ActiveSupport::Concern

  def search(relation)
    return relation unless search_params.present?
    @model = controller_name.classify.constantize

    relation = @model.search_by(search_params[:q])
  end

  private

  def search_params
    params.permit(:q, :page, :tab)
  end
end


