module Shared::Context
  module Manager
    def self.context_url_prefix
      return '' if Rails.module.university?
      '/' + self.current_context
    end

    def self.regex_context_url_prefix
      return '' if Rails.module.university?
      '\/' + self.current_context
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
      return 'root' unless ActiveRecord::Base.connection.table_exists? 'categories'

      category = Shared::Category.find_by(parent_id: nil)
      context = 'root' if !category || Rails.module.university?
      context = category.name if category && Rails.module.mooc?
      @context ||= context

      context
    end

    def self.default_question_context
      context = Shared::Tag.current_academic_year_value if Rails.module.university?
      context = Shared::Category.find_by(parent_id: nil).name if Rails.module.mooc?
      @question_context ||= context

      context
    end

    def self.context_category(context = current_context)
      Shared::Category.where(name: context).first
    end
  end
end
