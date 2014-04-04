module Probe
  class Search
    attr_accessor :index

    def initialize(index)
      @index = index
    end

    def client
      index.client
    end

    def search(query = {})
      results = client.search index: index.name, body: query

      Search::Results.new(results)
    end
  end
end
