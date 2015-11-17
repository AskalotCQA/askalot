module Shared::Searchables::Search
  extend ActiveSupport::Concern

  def search
    @model = ('Shared::' + controller_name.classify).constantize

    @results = @model.search_by(search_params)
  end

  private

  def search_params
    params.permit(:q, :page)
  end
end
