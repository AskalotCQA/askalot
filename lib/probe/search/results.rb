module Probe
  class Search
    class Results
      include Enumerable

      attr_reader :response, :results

      def initialize(response)
        @response = response
        @hits     = response['hits']
        @results  = @hits['hits'].map { |hit| OpenStruct.new(hit['_source']) }
      end

      def each
        results.each { |result| yield result }
      end

      def count
        results.count
      end

      alias :size :count
    end
  end
end
