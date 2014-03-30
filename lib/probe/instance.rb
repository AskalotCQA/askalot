module Probe
  module Instance
    def to_mapping
      mapper = self.class.probe.mapper

      mapper.map(self)
    end
  end
end
