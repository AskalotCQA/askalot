module Shared::Watchables::Watch
  extend ActiveSupport::Concern

  def watch
    @model     = controller_name.classify.downcase
    @watchable = ('Shared::' + controller_name.classify).constantize.find(params[:id])

    @watchable.toggle_watching_by! current_user

    render 'shared/watchables/watch', formats: :js
  end
end
