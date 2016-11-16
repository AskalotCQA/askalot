module Shared
class User
  class Profile < ActiveRecord::Base
    belongs_to :user, class_name: :'Shared::User'
    belongs_to :targetable, polymorphic: true

    symbolize :property
    symbolize :source

    scope :of, lambda { |type| where(property: type.to_s.camelize) }
    self.table_name = 'user_profiles'
  end
end
end
