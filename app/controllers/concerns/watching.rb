module Concerns::Watching
  extend ActiveSupport::Concern

  def register_watching_for(resource, watcher: current_user, **options)
    ::Watching.create! watcher: watcher, watchable: resource
  end
end
