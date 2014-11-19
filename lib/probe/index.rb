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
      return if exists?

      client.indices.create index: name, type: type, body: { settings: settings, mappings: mappings }

      flush
    end

    def delete
      client.indices.delete index: name if exists?
    end

    def reload
      delete
      create

      yield if block_given?

      flush
    end

    def mapper
      @mapper ||= Probe::Mapper.new
    end

    def import(documents, with: :simple, **options)
      importer = Probe::Import.of(with).new(self, Array.wrap(documents), options)

      importer.import

      flush
    end

    def size
      # TODO (smolnar) refactor
      stats['_all']['primaries']['docs']['count']
    end

    def stats
      client.indices.stats index: name
    end

    def flush
      client.indices.flush(index: name)
    end
  end
end
