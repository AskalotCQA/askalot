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
      category = Shared::Category.find_by(parent_id: nil, uuid: context)

      category ? category.id : default_context
    end

    def self.current_context=(context)
      @context = context
    end

    def self.current_context
      @context || default_context
    end

    def self.default_context(current_user = nil)
      return -1 unless ActiveRecord::Base.connection.table_exists? 'categories'

      category = Shared::Category.find_by(name: Shared::Tag.current_academic_year_value) if Rails.module.university?
      category = current_user.contexts.last if Rails.module.mooc? && !current_user.nil?

      context  = category ? category.id : 'default'

      @context ||= context

      context
    end
  end
end
