module Shared
class Configuration
  include Squire::Base

  squire.source Rails.root.join('config', 'configuration.yml')

  squire.namespace Rails.env_type.to_sym, base: :defaults
end
end
