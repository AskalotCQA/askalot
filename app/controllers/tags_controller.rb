class TagsController < ApplicationController
  include Searchables::Search
  include Watchables::Watch

  default_tab :all, only: :index
  default_tab :results, only: :search

  before_action :authenticate_user!

  def index
    @tags = Tag.order(:name)
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
