module Probe
  class Analyze
    attr_accessor :index, :client

    def initialize(index)
      @index = index
    end

    def client
      index.client
    end

    def analyze(options)
      result = client.indices.analyze({ index: index.name }.merge(options))

      result['tokens'].map { |token| token['token'] }
    end
  end
end
