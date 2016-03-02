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
      category = Shared::Category.find_by(parent_id: nil, name: context)

      category ? category.id : 1
    end

    def self.current_context=(context)
      @context = context
    end

    def self.current_context
      @context || default_context
    end

    def self.question_context=(context)
      @question_context = context
    end

    def self.question_context
      @question_context || default_question_context
    end

    def self.default_context
      return -1 unless ActiveRecord::Base.connection.table_exists? 'categories'

      category = Shared::Category.find_by(parent_id: nil, name: 'root') if Rails.module.university?
      category = Shared::Category.find_by(parent_id: nil) unless Rails.module.university?
      context  = category ? category.id : 1

      @context ||= context

      context
    end

    def self.default_question_context
      category = Shared::Category.find_by(name: Shared::Tag.current_academic_year_value) if Rails.module.university?
      category = Shared::Category.find_by(parent_id: nil) unless Rails.module.university?
      context  = category ? category.id : 1

      @question_context ||= context

      context
    end
  end
end
