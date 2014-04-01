module Searchable
  extend ActiveSupport::Concern

  included do
    include Probe
  end
end
