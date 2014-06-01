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
      query.reverse_merge(from: 0, size: 25)

      Results.new(query) { client.search index: index.name, body: query }
    end
  end
end
