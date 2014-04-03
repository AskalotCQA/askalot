require 'probe/index'
require 'probe/mapper'
require 'probe/proxy'
require 'probe/base'
require 'probe/import'
require 'probe/import/simple'
require 'probe/import/bulk'
require 'probe/search/results'
require 'probe/search'
require 'probe/analyze'
require 'probe/sanitizer'

module Probe
  extend ActiveSupport::Concern

  def probe
    @probe ||= Probe::Base.new(self)
  end

  def to_mapping
    probe.to_mapping
  end

  module ClassMethods
    def probe
      @probe ||= Probe::Proxy.new
    end
  end
end
