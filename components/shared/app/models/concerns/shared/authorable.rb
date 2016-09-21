module Shared::Authorable
  extend ActiveSupport::Concern

  included do
    belongs_to :author, class_name: :'Shared::User', counter_cache: true

    def author_or_anonymous
      return author unless self.respond_to? :anonymous

      self.anonymous ? :anonymous : author
    end

    def page_url_prefix
      return '' unless self.respond_to? :to_question

      self.to_question.category.root.askalot_page_url + '#'
    end
  end
end
