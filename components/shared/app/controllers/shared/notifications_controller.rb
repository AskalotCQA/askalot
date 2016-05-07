module Shared
class NotificationsController < ApplicationController
  default_tab :unread, only: [:index, :read, :unread, :clean]

  before_action :authenticate_user!

  def index
    count = 20

    @notifications = Shared::Notification.in_context(@context).for(current_user).order(created_at: :desc)

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
    @notifications = Shared::Notification.in_context(@context).where(recipient: current_user).unread

    if @notifications.update_all(unread: false, read_at: nil)
      form_message :notice, t('notification.clean.success'), key: params[:tab]
    else
      form_error_message t('notification.clean.failure'), key: params[:tab]
    end

    redirect_to :back
  end

  private

  def mark(status)
    @notification = Shared::Notification.find(params[:id])

    if @notification.public_send("mark_as_#{status}")
      form_message :notice, t("notification.#{status}.success"), key: params[:tab]
    else
      form_error_message t("notification.#{status}.failure"), key: params[:tab]
    end

    respond_to do |format|
      format.html { redirect_to(params[:r] ? params[:r] : :back) }
      format.js   { render 'shared/shared/notification', format: :js }
    end
  end
end
end
