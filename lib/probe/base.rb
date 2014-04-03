module Probe
  class Instance
    attr_reader :instance

    def initialize(instance)
      @instance = instance
    end

    def index
      instance.class.probe.index
    end

    def to_mapping
      index.mapper.map(instance)
    end
  end
end
