module University::Watchables::Watch
  extend ActiveSupport::Concern

  def watch
    @model     = controller_name.classify.downcase.to_sym
    @watchable = controller_name.classify.constantize.find(params[:id])

    @watchable.toggle_watching_by! current_user

    render 'watchables/watch', formats: :js
  end
end
