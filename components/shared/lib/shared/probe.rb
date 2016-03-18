require 'shared/probe/index'
require 'shared/probe/mapper'
require 'shared/probe/proxy'
require 'shared/probe/base'
require 'shared/probe/import'
require 'shared/probe/import/simple'
require 'shared/probe/import/bulk'
require 'shared/probe/results/kaminari'
require 'shared/probe/results'
require 'shared/probe/search'
require 'shared/probe/analyze'
require 'shared/probe/sanitizer'

module Shared::Probe
  extend ActiveSupport::Concern

  def probe
    @probe ||= Shared::Probe::Base.new(self)
  end

  def to_mapping
    probe.to_mapping
  end

  module ClassMethods
    def probe
      @probe ||= Shared::Probe::Proxy.new
    end
  end
end
