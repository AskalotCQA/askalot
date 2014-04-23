class ActivitiesController < ApplicationController

  default_tab :global, only: :index

  def index
    @global    = Activity.global.order(created_at: :desc)
    @followees = Activity.by_followees_of(current_user).order(created_at: :desc)

    @global    = @global.page(tab_page :global).per(20)
    @followees = @followees.page(tab_page :followees).per(20)
  end
end
