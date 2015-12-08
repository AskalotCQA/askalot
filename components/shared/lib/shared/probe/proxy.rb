require_dependency 'shared/probe/search'
require_dependency 'shared/probe/analyze'
require_dependency 'shared/probe/index'
require_dependency 'shared/probe/sanitizer'

module Shared::Probe
  class Proxy
    include Squire

    attr_accessor :index, :search, :analyze, :sanitizer

    def index
      @index ||= Shared::Probe::Index.new
    end

    def search(*args)
      @search ||= Shared::Probe::Search.new(index)

      @search.search(*args)
    end

    def analyze(*args)
      @analyze ||= Shared::Probe::Analyze.new(index)

      @analyze.analyze(*args)
    end

    def sanitizer
      @sanitizer ||= Shared::Probe::Sanitizer
    end
  end
end
