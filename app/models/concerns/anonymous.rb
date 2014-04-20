module Anonymous
  extend ActiveSupport::Concern

  included do
    def user_or_anonymous
      self.anonymous? ? :anonymous : self.initiator
    end
  end
end
