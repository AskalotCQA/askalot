class NotificationsController < ApplicationController
  include Tabbing

  default_tab :unread, only: :index

  before_action :authenticate_user!

  def index
    count = 25

    @notifications = Notification.where(recipient: current_user).order(created_at: :desc)

    @unread = @notifications.unread.page(tab_page :unread).per(count)
    @all    = @notifications.page(tab_page :all).per(count)
  end
end
