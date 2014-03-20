class WatchingsController < ApplicationController
  include Tabbing

  default_tab :questions, only: :index

  before_action :authenticate_user!

  def index
    count = 25

    @watchings = Watching.where(watcher: current_user).order(created_at: :desc)

    @questions  = @watchings.of(:question).page(tab_page :questions).per(count)
    @categories = @watchings.of(:category).page(tab_page :categories).per(count)
    @tags       = @watchings.of(:tag).page(tab_page :tags).per(count)
  end

  def delete
    @watching = Notification.find(params[:id])

    if @watching.destroy
      form_message :notice, t('watching.delete.success'), key: params[:tab]
    else
      form_error_message t('watching.delete.failure'), key: params[:tab]
    end

    redirect_to :back
  end
end
