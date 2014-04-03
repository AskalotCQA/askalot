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
      size = query.delete(:per_page) || 20
      from = (query.delete(:page) || 0) * size

      results = probe.search(query.revese_merge(from: from, size: size))

      results.map { |result| find(result.id) }
    end
  end
end
