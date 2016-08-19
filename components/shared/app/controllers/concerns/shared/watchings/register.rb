module Shared::Watchings::Register
  extend ActiveSupport::Concern

  def register_watching_for(resource, watcher: current_user, **options)
    ::Shared::Watching.deleted_or_new(watcher: watcher, watchable: resource, context: @context_id).mark_as_undeleted!
  end
end
