module Shared
class TagsController < ApplicationController
  include Shared::Searchables::Search
  include Shared::Watchables::Watch

  default_tab :all, only: :index
  default_tab :results, only: :search

  before_action :authenticate_user!

  def index
    @tags = case params[:tab].to_sym
            when :recent then Shared::Tag.in_context(@context_id).recent
            when :popular then Shared::Tag.in_context(@context_id).popular
            else Shared::Tag.in_context(@context_id).order(:name)
    end

    @tags = @tags.page(params[:page]).per(60)
  end

  def suggest
    @tags = Shared::Tag.search_by(q: params[:q]).results.limit(10)

    render json: @tags, root: :results, adapter: :json
  end
end
end
