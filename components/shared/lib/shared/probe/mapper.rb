module Shared::Probe
  class Mapper
    attr_reader :definitions

    def definitions
      @definitions ||= Hash.new
    end

    def define(other)
      definitions.deep_merge!(other)
    end

    def map(record)
      definitions.inject({}) do |result, (name, callback)|
        result[name] = record.instance_exec(&callback)

        result
      end
    end
  end
end
