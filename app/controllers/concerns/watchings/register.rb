module Watchings::Register
  extend ActiveSupport::Concern

  def register_watching_for(resource, watcher: current_user, **options)
    watching = ::Watching.deleted_or_new watcher: watcher, watchable: resource
    watching.unmark_as_deleted!
  end
end
