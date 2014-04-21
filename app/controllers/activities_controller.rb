class ActivitiesController < ApplicationController

  default_tab :global, only: :index

  def index
    @activities_global    = Activity.global.order(created_at: :desc)
    @activities_followees = Activity.by_followees_of(current_user).order(created_at: :desc)

    @activities_global    = @activities_global.page(tab_page :global).per(20)
    @activities_followees = @activities_followees.page(tab_page :followees).per(20)
  end
end
