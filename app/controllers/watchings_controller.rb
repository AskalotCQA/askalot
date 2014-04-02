class WatchingsController < ApplicationController
  default_tab :questions, only: [:index, :destroy, :clean]

  before_action :authenticate_user!

  def index
    count = 20

    @watchings = Watching.by(current_user).order(created_at: :desc)

    @questions  = @watchings.of(:question).page(tab_page :questions).per(count)
    @categories = @watchings.of(:category).page(tab_page :categories).per(count)
    @tags       = @watchings.of(:tag).page(tab_page :tags).per(count)
  end

  def destroy
    @watching = Watching.find(params[:id])

    if @watching.destroy
      form_message :notice, t('watching.delete.success'), key: params[:tab]
    else
      form_error_message t('watching.delete.failure'), key: params[:tab]
    end

    redirect_to :back
  end

  def clean
    @watchings = Watching.where(watcher: current_user, watchable_type: params[:type].classify)

    if @watchings.destroy_all
      form_message :notice, t('watching.clean.success'), key: params[:tab]
    else
      form_error_message t('watching.clean.failure'), key: params[:tab]
    end

    redirect_to :back
  end
end
