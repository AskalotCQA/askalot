module University
class TagsController < ApplicationController
  include University::Searchables::Search
  include University::Watchables::Watch

  default_tab :all, only: :index
  default_tab :results, only: :search

  before_action :authenticate_user!

  def index
    @tags = case params[:tab].to_sym
            when :recent then Tag.recent
            when :popular then Tag.popular
            else Tag.order(:name)
            end
  end

  # TODO (smolnar)
  # * use elasticsearch
  # * consider pagination

  def suggest
    @tags = Tag.search_by(q: params[:q]).first(10)

    render json: {
      results: @tags.map { |tag|
        {
          id:   tag.name,
          text: "#{tag.name} (#{tag.count})"
        }
      },
    }
  end
end
end
