module Shared::Context
  module Manager
    def self.context_url_prefix
      return '' if Rails.module.university?
      "/#{self.context_category.uuid}"
    end

    def self.regex_context_url_prefix
      return '' if Rails.module.university?
      "\\/#{self.context_category.uuid}"
    end

    def self.determine_context_id(context)
      category = Shared::Category.find_by(parent_id: nil, id: context) if context.is_number?
      category = Shared::Category.find_by(parent_id: nil, uuid: context) unless context.is_number?

      category ? category.id : default_context_id
    end

    def self.current_context_id=(context_id)
      @context_id = context_id

      @context_category = Shared::NullContextCategory.new if context_id == -1
      @context_category = Shared::Category.find(context_id) unless context_id == -1
    end

    def self.current_context_id
      @context_id || default_context_id
    end

    def self.context_category
      @context_category || Shared::NullContextCategory.new
    end

    def self.default_context_id(current_user = nil)
      return -1 unless ActiveRecord::Base.connection.table_exists? 'categories'

      category = Shared::Category.find_by(name: Shared::Tag.current_academic_year_value) if Rails.module.university?
      category = current_user.contexts.last if Rails.module.mooc? && !current_user.nil?

      context  = category ? category.id : -1

      context
    end
  end
end
