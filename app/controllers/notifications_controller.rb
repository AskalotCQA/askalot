class NotificationsController < ApplicationController
  include Tabbing

  default_tab :unread, only: :index

  before_action :authenticate_user!

  def index
    count = 25

    @notifications = Notification.where(recipient: current_user).where.not(notifiable_type: [:view, :vote]).order(created_at: :desc)

    @unread = @notifications.unread.page(tab_page :unread).per(count)
    @all    = @notifications.page(tab_page :all).per(count)
  end

  def read
    @notification = Notification.find(params[:id])

    @notification.unread = false

    if @notification.save
      form_message :notice, t('notification.read.success'), key: params[:tab]
    else
      form_error_message t('notification.read.failure'), key: params[:tab]
    end

    redirect_to :back
  end
end
