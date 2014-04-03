module Searchable
  extend ActiveSupport::Concern

  included do
    include Probe

    after_save do
      # TODO (smolnar) consider update
      self.class.probe.index.import(self)
    end

    after_destroy do
      self.class.probe.index.import(self, action: :delete)
    end
  end

  module ClassMethods
    def search(query = {})
      size = query.delete(:per_page) || 25
      from = (query.delete(:page) || 0) * size

      results = probe.search({ from: from, size: size }.merge(query))

      results.map { |result| find(result.id) }
    end
  end
end
