module Probe
  class Index
    attr_accessor :name, :type, :client, :settings, :mappings

    def initialize(name: nil, type: nil, **options)
      @name    = name
      @type    = type
      @options = options
    end

    def client
      @client ||= Elasticsearch::Client.new
    end

    def exists?
      client.indices.exists index: name
    end

    def create
      delete if exists?

      client.indices.create index: name, type: type, body: { settings: settings, mapping:  mappings }
    end

    def delete
      client.indices.delete index: name
    end

    def mapper
      @mapper ||= Probe::Mapper.new
    end

    def import(documents)
      # TODO (smolnar) Bulk

      method = documents.respond_to?(:find_each) ? :find_each : :each

      documents.public_send(method) do |document|
        client.index(index: name, type: type, body: mapper.map(document))
      end
    end
  end
end
