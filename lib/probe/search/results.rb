module Probe
  class Search
    class Results
      include Enumerable

      attr_reader   :response, :results
      attr_accessor :loader

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

      def offset
        @offset ||= page * per_page
      end

      def current_page
        @current_page ||= @query[:page] || 0
      end

      def previous_page
        @previous_page ||= current_page > 0 ? current_page - 1 : nil
      end

      def next_page
        @next_page ||= current_page < total_pages ? current_page + 1 : nil
      end

      def per_page
        @per_page ||= @query[:per_page] || 20
      end

      def total_pages
        @total_pages ||= total_entries / per_page
      end

      def total_entries
        @total_entries ||= @response['hits']['total']
      end

      def results
        @results ||= begin
          results = response['hits']['hits'].map { |hit| OpenStruct.new(hit['_source']) }
          results = loader.call(results) if loader.respond_to?(:call)

          results
        end
      end

      def response
        @response = @search.call
      end

      alias :size :count
      alias :limit_value  :per_page
      alias :total_count  :total_entries
      alias :num_pages    :total_pages
      alias :offset_value :offset
      alias :page         :current_page
    end
  end
end
