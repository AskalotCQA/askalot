module University::Watchables::Watch
  extend ActiveSupport::Concern

  def watch
    @model     = controller_name.classify.downcase
    @watchable = ('University::' + controller_name.classify).constantize.find(params[:id])

    @watchable.toggle_watching_by! current_user

    render 'university/watchables/watch', formats: :js
  end
end
