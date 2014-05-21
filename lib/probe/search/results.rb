module Probe
  class Search
    class Results
      include Enumerable

      attr_reader :response, :results

      def initialize(response)
        @response = response
        @hits     = response['hits']
        @results  = @hits['hits'].map do |hit|
          if hit['_source']
            data = hit['_source']
          else
            data = hit['fields'].inject(Hash.new) do |hash, (key, value)|
              hash[key] = value.size > 1 ? value : value.first

              hash
            end
          end

          OpenStruct.new(data)
        end
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
