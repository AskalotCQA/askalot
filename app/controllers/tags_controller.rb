class TagsController < ApplicationController
  # TODO (smolnar) 
  # * remove AR relation, use elasticsearch
  # * use pagination

  def suggest
    relation = ActsAsTaggableOn::Tagging.where(taggable_type: params[:type].camelcase, context: params[:context] || :tags)

    tags = relation.joins(:tag).where('tags.name LIKE ?', "#{params[:q]}%").select('tags.name').limit(10).distinct

    render json: {
      results: tags.uniq.map { |e| { id: e.name, text: e.name }},
    }
  end
end
