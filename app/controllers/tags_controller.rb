class TagsController < ApplicationController
  before_action :authenticate_user!

  # TODO (smolnar)
  # * use elasticsearch
  # * consider pagination

  def suggest
    tags = Tag.where('tags.name LIKE ?', "#{params[:q]}%").limit(10).order(:name)

    render json: {
      results: tags.map { |tag|
        {
          id:    tag.name,
          text: "#{tag.name} (#{tag.taggings.size})"
        }
      },
    }
  end
end
