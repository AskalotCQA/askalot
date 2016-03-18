module Shared::Probe
  class Analyze
    attr_accessor :index, :client

    def initialize(index)
      @index = index
    end

    def client
      index.client
    end

    def analyze(options)
      result = client.indices.analyze(options.reverse_merge(index: index.name))

      result['tokens'].map { |token| token['token'] }
    end
  end
end
