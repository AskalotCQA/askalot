module Searchable
  extend ActiveSupport::Concern

  included do
    include Probe
    include Orderable

    after_save do
      self.class.probe.index.import(self)
    end

    after_destroy do
      self.class.probe.index.import(self, action: :delete)
    end
  end

  module ClassMethods
    def search(query = {})
      page    = query.delete(:page) || 0
      size    = query.delete(:per_page) || 30
      from    = (page <= 0 ? 0 : page - 1) * size
      model   = self
      results = probe.search(query.reverse_merge(from: from, size: size))

      results.loader = lambda do |sources|
        ids = sources.map(&:id)

        model.where(id: ids).order_by(id: ids)
      end

      results
    end
  end
end
