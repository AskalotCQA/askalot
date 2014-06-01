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
      Search::Results.new(query) { client.search index: index.name, body: query }
    end
  end
end
