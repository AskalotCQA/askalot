module Probe
  class Proxy
    include Squire

    def index
      @index ||= Probe::Index.new
    end
  end
end
