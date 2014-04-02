module Probe
  class Proxy
    include Squire

    def index
      @index ||= Probe::Index.new
    end

    def search
      @search ||= Probe::Search.new(index)
    end
  end
end
