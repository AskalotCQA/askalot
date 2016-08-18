module Shared::Context
  module Manager
    def self.context_url_prefix
      return '' if Rails.module.university?
      "/#{self.current_context}"
    end

    def self.regex_context_url_prefix
      return '' if Rails.module.university?
      "\\/#{self.current_context}"
    end

    def self.determine_context_id(context)
      category = Shared::Category.find_by(parent_id: nil, id: context) if context.is_number?
      category = Shared::Category.find_by(parent_id: nil, uuid: context) unless context.is_number?

      category ? category.id : default_context
    end

    def self.current_context=(context)
      @context = context

      @context_category = Shared::NullContextCategory.new if context == 'default'
      @context_category = Shared::Category.find(context) unless context == 'default'
    end

    def self.current_context
      @context || default_context
    end

    def self.context_category
      @context_category || Shared::NullContextCategory.new
    end

    def self.default_context(current_user = nil)
      return -1 unless ActiveRecord::Base.connection.table_exists? 'categories'

      category = Shared::Category.find_by(name: Shared::Tag.current_academic_year_value) if Rails.module.university?
      category = current_user.contexts.last if Rails.module.mooc? && !current_user.nil?

      context  = category ? category.id : 'default'

      context
    end
  end
end
