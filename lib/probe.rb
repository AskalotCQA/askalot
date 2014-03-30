require 'probe/index'
require 'probe/mapper'
require 'probe/proxy'

module Probe
  extend ActiveSupport::Concern

  module ClassMethods
    def probe
      @probe ||= Probe::Proxy.new
    end
  end
end
