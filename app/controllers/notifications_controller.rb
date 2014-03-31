class NotificationsController < ApplicationController
  default_tab :unread, only: [:index, :read, :clean]

  before_action :authenticate_user!

  def index
    count = 25

    @notifications = Notification.where(recipient: current_user).order(created_at: :desc)

    @unread = @notifications.unread.page(tab_page :unread).per(count)
    @all    = @notifications.page(tab_page :all).per(count)
  end

  def read
    mark :read
  end

  def unread
    mark :unread
  end

  def clean
    @notifications = Notification.where(recipient: current_user).unread

    if @notifications.update_all(unread: false)
      form_message :notice, t('notification.clean.success'), key: params[:tab]
    else
      form_error_message t('notification.clean.failure'), key: params[:tab]
    end

    redirect_to :back
  end

  private

  def mark(status)
    @notification = Notification.find(params[:id])

    @notification.unread = (status == :read ? false : (status == :unread) ? true : fail)

    if @notification.save
      form_message :notice, t("notification.#{status}.success"), key: params[:tab]
    else
      form_error_message t("notification.#{status}.failure"), key: params[:tab]
    end

    redirect_to :back
  end
end
