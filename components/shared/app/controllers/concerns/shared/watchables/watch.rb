module Shared::Watchables::Watch
  extend ActiveSupport::Concern

  def watch
    @model     = controller_name.classify.downcase
    @watchable = controller_path.classify.constantize.find(params[:id])

    @watchable.toggle_watching_by! current_user

    render 'shared/watchables/watch', formats: :js
  end
end
