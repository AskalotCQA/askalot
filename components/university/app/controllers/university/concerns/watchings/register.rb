module University::Watchings::Register
  extend ActiveSupport::Concern

  def register_watching_for(resource, watcher: current_user, **options)
    ::Watching.deleted_or_new(watcher: watcher, watchable: resource).mark_as_undeleted!
  end
end
