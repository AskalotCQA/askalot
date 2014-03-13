class NotificationsController < ApplicationController
  include Tabbing

  default_tab :unread, only: :index

  before_action :authenticate_user!

  def index
    @notifications = Notification.where(recipient: current_user).order(created_at: :desc).page(params[:page]).per(20)
  end
end
