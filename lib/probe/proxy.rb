module Probe
  class Proxy
    include Squire

    attr_accessor :index, :search, :analyze, :sanitizer

    def index
      @index ||= Probe::Index.new
    end

    def search(*args)
      @search ||= Probe::Search.new(index)

      @search.search(*args)
    end

    def analyze(*args)
      @analyze ||= Probe::Analyze.new(index)

      @analyze.analyze(*args)
    end

    def sanitizer
      @sanitizer ||= Probe::Sanitizer
    end
  end
end
