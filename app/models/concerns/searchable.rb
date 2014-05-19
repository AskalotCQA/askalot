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
      total    = self.count
      results  = probe.search(query.reverse_merge(size: total, fields: [:id]))
      ids      = results.map(&:id)

      self.where(questions: { id: ids }).order_by(id: ids)
    end
  end
end
