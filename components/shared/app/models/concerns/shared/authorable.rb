module Shared::Authorable
  extend ActiveSupport::Concern

  included do
    belongs_to :author, class_name: :'Shared::User', counter_cache: true

    def author_or_anonymous
      return author unless self.respond_to? :anonymous

      self.anonymous ? :anonymous : author
    end
  end
end
