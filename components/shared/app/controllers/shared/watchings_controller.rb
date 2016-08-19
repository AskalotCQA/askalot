module Shared
class WatchingsController < ApplicationController
  default_tab :questions, only: [:index, :destroy, :clean]

  before_action :authenticate_user!

  def index
    count = 20

    @watchings  = Shared::Watching.in_context(@context_id).by(current_user).order(created_at: :desc)
    @questions  = @watchings.of('Shared::Question').page(tab_page :questions).per(count)
    @tags       = @watchings.of('Shared::Tag').page(tab_page :tags).per(count)
    @categories = @watchings.of('Shared::Category')
      .includes('category')
      .reorder(
        "CASE
          WHEN (watchable_id IN (#{Shared::Category::all_in_contexts(@context_id).select('id').to_sql})) THEN 1
          ELSE 2
        END",
        'categories.full_tree_name'
      ).page(tab_page :categories).per(count)
  end

  def destroy
    @watching = Shared::Watching.find(params[:id])

    begin
      @watching.mark_as_deleted_by! current_user
    rescue
      form_error_message t('watching.delete.failure'), key: params[:tab]
    else
      form_message :notice, t('watching.delete.success'), key: params[:tab]
    end

    redirect_to :back
  end

  def clean
    @watchings = Shared::Watching.in_context(@context_id).where(watcher: current_user, watchable_type: "Shared::#{params[:type].classify.capitalize}")

    begin
      @watchings.each { |watching| watching.mark_as_deleted_by! current_user }
    rescue
      form_error_message t('watching.clean.failure'), key: params[:tab]
    else
      form_message :notice, t('watching.clean.success'), key: params[:tab]
    end

    redirect_to :back
  end
end
end
