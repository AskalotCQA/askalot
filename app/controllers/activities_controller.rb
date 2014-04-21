class ActivitiesController < ApplicationController

  default_tab :global

  def index
    @activities_global = Activity.global.order(created_at: :desc)
    @activities_follow = Activity.by_followees_of(current_user).order(created_at: :desc)

    @activities_global = @activities_global.page(tab_page :global).per(5)
    @activities_follow = @activities_follow.page(tab_page :follow).per(5)
  end
end
