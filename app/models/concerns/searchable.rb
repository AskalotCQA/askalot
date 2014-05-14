module Searchable
  extend ActiveSupport::Concern

  included do
    include Orderable
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
      total   = self.count
      size    = query.delete(:per_page) || 20
      from    = (query.delete(:page) || 0) * size
      results = probe.search(query.reverse_merge(from: from, size: total))
      ids     = results.map(&:id)

      self.where(id: ids).order_by(id: ids).limit(size)
    end
  end
end
