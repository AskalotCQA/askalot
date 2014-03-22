module
  extend ActiveSupport::Concern

  included do
    has_many :activities, as: :resource
  end
end
