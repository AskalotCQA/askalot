module Shared
class WatchingsController < ApplicationController
  default_tab :questions, only: [:index, :destroy, :clean]

  before_action :authenticate_user!

  def index
    count = 20
    @context = Shared::ApplicationHelper.current_context
    @watchings = Shared::Watching.in_context(@context).by(current_user).order(created_at: :desc)

    @questions  = @watchings.of('Shared::Question').page(tab_page :questions).per(count)
    @categories = @watchings.of('Shared::Category').page(tab_page :categories).per(count)
    @tags       = @watchings.of('Shared::Tag').page(tab_page :tags).per(count)
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
    context = Shared::ApplicationHelper.current_context
    @watchings = Shared::Watching.in_context(context).where(watcher: current_user, watchable_type: params[:type].classify)

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
