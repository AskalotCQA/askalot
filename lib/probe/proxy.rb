module Probe
  class Proxy
    include Squire

    attr_accessor :index, :search

    def index
      @index ||= Probe::Index.new
    end

    def search(*args)
      # TODO (smolnar) refactor
      @search ||= Probe::Search.new(index)

      @search.search(*args)
    end
  end
end
