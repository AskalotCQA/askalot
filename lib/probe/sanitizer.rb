module Probe
  module Sanitizer
    extend self

    def sanitize_query(value)
      value = value.gsub(/(\+|\-|&&|\||\||\(|\)|\{|\}|\[|\]|\^|~|\!|\\|\/|:)/) { |m| "\\#{m}" }

      value[value.rindex('"')] = "\\\"" unless value.count('"') % 2 == 0

      value
    end
  end
end
