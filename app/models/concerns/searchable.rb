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

      model   = self
      results = probe.search(query.reverse_merge(from: from, size: size))

      results.loader = lambda do |results|
        results.map { |result| model.find(result.id) }
      end

      results
    end
  end
end
