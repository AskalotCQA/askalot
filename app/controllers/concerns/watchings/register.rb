module Watchings::Register
  extend ActiveSupport::Concern

  def register_watching_for(resource, watcher: current_user, **options)
    ::Watching.deleted_or_new(watcher: watcher, watchable: resource).unmark_as_deleted!
  end
end
