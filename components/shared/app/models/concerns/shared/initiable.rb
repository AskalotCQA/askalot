module Shared::Initiable
  extend ActiveSupport::Concern

  included do
    def initiator_or_anonymous
      self.anonymous? ? :anonymous : self.initiator
    end
  end
end
