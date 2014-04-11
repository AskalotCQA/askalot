class User
  class Profile < ActiveRecord::Base
    belongs_to :user
    belongs_to :targetable, polymorphic: true

    symbolize :property
    symbolize :source

    scope :of, lambda { |type| where(targetable_type: type.to_s.camelize) }
  end
end
