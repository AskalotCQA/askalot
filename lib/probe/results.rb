module Probe
  class Results
    include Enumerable

    attr_reader   :query, :response, :hits, :results
    attr_accessor :loader

    def initialize(query, &search)
      @query  = query
      @search = search
    end

    def each
      results.each { |result| yield result }
    end

    def offset
      @offset ||= current_page * per_page
    end

    def current_page
      @current_page ||= (query[:from] / per_page) + 1
    end

    def previous_page
      @previous_page ||= current_page > 1 ? current_page - 1 : nil
    end

    def next_page
      @next_page ||= current_page <= total_pages ? current_page + 1 : nil
    end

    def per_page
      @per_page ||= query[:size]
    end

    def total_pages
      @total_pages ||= total_entries / per_page
    end

    def total_entries
      @total_entries ||= response['hits']['total']
    end

    def response
      @response ||= @search.call
    end

    def hits
      response['hits']
    end

    def results
      @results ||= loader ? loader.call(original_results) : original_results
    end

    def original_results
      @original_results ||= hits['hits'].map { |hit| OpenStruct.new(hit['_source']) }
    end

    include Results::Kaminari
  end
end
