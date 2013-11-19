class Social
  include Squire::Base

  squire.source Rails.root.join('config', 'social.yml')

  squire.namespace Rails.env.to_sym, base: :defaults
end
