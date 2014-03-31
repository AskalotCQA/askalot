require 'probe/index'
require 'probe/mapper'
require 'probe/proxy'
require 'probe/instance'
require 'probe/import'
require 'probe/import/simple'
require 'probe/import/bulk'

module Probe
  extend ActiveSupport::Concern

  included do
    include Probe::Instance
  end

  module ClassMethods
    def probe
      @probe ||= Probe::Proxy.new
    end
  end
end
