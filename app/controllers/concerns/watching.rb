module Concerns::Watching
  extend ActiveSupport::Concern

  def register_watching_for(resource, watcher: current_user, **options)
    ::Watching.find_or_create_by! watcher: watcher, watchable: resource
  end
end
