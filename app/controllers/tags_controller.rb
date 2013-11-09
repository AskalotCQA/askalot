class TagsController < ApplicationController
  def suggest
    relation = ActsAsTaggableOn::Tagging.where(taggable_type: params[:type].camelcase, context: params[:context] || :tags)

    tags = relation.joins(:tag).where('tags.name LIKE ?', "#{params[:q]}%").map { |e| e.tag }

    render json: tags.map { |e| { id: e.name, text: e.name }}
  end
end
