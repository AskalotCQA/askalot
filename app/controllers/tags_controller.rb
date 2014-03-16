class TagsController < ApplicationController
  include Tabbing

  before_action :authenticate_user!

  default_tab :'tags-all', only: :index

  def index
    @tags = case params[:tab].to_sym
            when :'tags-all'      then Tag.order(:name)
            when :'tags-recent'      then Tag.order(:created_at)
            when :'tags-popular'  then Tag.popular
            else fail
            end
  end

  # TODO (smolnar)
  # * use elasticsearch
  # * consider pagination

  def suggest
    tags = Tag.where('tags.name LIKE ?', "#{params[:q]}%").limit(10).order(:name)

    render json: {
      results: tags.map { |tag|
        {
          id:    tag.name,
          text: "#{tag.name} (#{tag.count})"
        }
      },
    }
  end
end
