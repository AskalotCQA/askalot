class TagsController < ApplicationController
  include Searchables::Search
  include Watchables::Watch

  default_tab :all, only: :index

  before_action :authenticate_user!

  def index
    @tags = Tag.order(:name)
  end

  # TODO (smolnar)
  # * use elasticsearch
  # * consider pagination

  def suggest
    tags = Tag.where('tags.name LIKE ?', "#{params[:q]}%").limit(10).order(:name)

    render json: {
      results: tags.map { |tag|
        {
          id: tag.name,
          text: "#{tag.name} (#{tag.count})"
        }
      },
    }
  end
end
