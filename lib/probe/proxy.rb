module Probe
  class Proxy
    include Squire

    attr_accessor :index, :search

    def index
      @index ||= Probe::Index.new
    end

    def search
      @search ||= Probe::Search.new(index)
    end
  end
end
