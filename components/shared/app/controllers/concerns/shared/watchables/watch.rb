module Shared::Watchables::Watch
  extend ActiveSupport::Concern

  include Shared::Events::Dispatch

  def watch
    @model     = controller_name.classify.downcase
    @watchable = controller_path.classify.constantize.find(params[:id])

    @watching = @watchable.toggle_watching_by! current_user

    case @watching.watchable_type
    when 'Shared::Category' then recipient = @watchable.teachers
    when 'Shared::Question' then recipient = @watchable.author
    else recipient = @watchable.watchers
    end

    dispatch_event dispatch_event_action_for(@watching), @watching, for: recipient

    render 'shared/watchables/watch', formats: :js
  end
end
