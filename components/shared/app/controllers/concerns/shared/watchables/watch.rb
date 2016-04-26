module Shared::Watchables::Watch
  extend ActiveSupport::Concern

  include Shared::Events::Dispatch

  def watch
    @model     = controller_name.classify.downcase
    @watchable = controller_path.classify.constantize.find(params[:id])

    @watching = @watchable.toggle_watching_by! current_user

    if @watchable.watched_by? current_user
      dispatch_event dispatch_event_action_for(@watching), @watching, for: @watchable.watchers
    end

    render 'shared/watchables/watch', formats: :js
  end
end
