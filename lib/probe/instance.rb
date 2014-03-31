module Probe
  module Instance
    def to_mapping
      self.class.probe.index.mapper.map(self)
    end
  end
end
