module Probe
  class Import
    include Enumerable

    attr_reader :index, :documents, :action, :options

    def initialize(index, documents, options = {})
      @index     = index
      @documents = documents
      @options   = options
      @action    = options[:action] || :index
    end

    def client
      index.client
    end

    def each(&block)
      method = documents.respond_to?(:find_each) ? :find_each : :each

      documents.public_send(method).each { |document| yield document }
    end

    def self.of(type)
      case type
      when :simple then Probe::Import::Simple
      when :bulk   then Probe::Import::Bulk
      else raise ArgumentError.new("Unknown type '#{type}' for import")
      end
    end
  end
end
