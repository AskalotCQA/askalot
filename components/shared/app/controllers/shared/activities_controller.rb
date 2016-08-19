module Shared
class ActivitiesController < ApplicationController
  default_tab :all, only: :index

  before_action :authenticate_user!

  def index
    count = 20

    @global    = Shared::Activity.in_context(@context_id).global.order(created_at: :desc)
    @followees = Shared::Activity.in_context(@context_id).by_followees_of(current_user).order(created_at: :desc)

    @global    = @global.page(tab_page :all).per(count)
    @followees = @followees.page(tab_page :followees).per(count)
  end
end
end
