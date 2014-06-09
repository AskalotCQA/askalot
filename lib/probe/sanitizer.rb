module Probe
  module Sanitizer
    extend self

    def sanitize_query(query)
      # TODO (smolnar) implement
      query.gsub(/[^a-z0-9?_]/i, "")
    end
  end
end
