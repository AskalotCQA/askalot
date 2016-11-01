module Shared
class User
  class Profile < ActiveRecord::Base
    belongs_to :user, class_name: :'Shared::User'
    belongs_to :targetable, polymorphic: true

    symbolize :property
    symbolize :source

    scope :of, lambda { |type| where(property: type.to_s.camelize) }
    scope :get_feature, lambda { |type| of(type).first_or_create(targetable_id: -1,
                                                                 targetable_type: type,
                                                                 property: type) }

    self.table_name = 'user_profiles'
  end
end
end
