class TagsController < ApplicationController
  # TODO (smolnar)
  # * remove AR relation, use elasticsearch
  # * use pagination

  def suggest
    tags = Tag.where('tags.name LIKE ?', "#{params[:q]}%").limit(10)

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
