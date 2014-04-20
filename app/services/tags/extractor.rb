module Tags
  module Extractor
    extend self

    def extract(values)
      (values.is_a?(Array) ? values.map(&:to_s) : values.to_s.split(/,/)).map(&:strip)
    end
  end
end
