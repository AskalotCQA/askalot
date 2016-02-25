module Shared::Context
  class Manager
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
      context = :root if Rails.module.university?
      context = Shared::Category.find_by(parent_id: nil).name if Rails.module.mooc?
      @context ||= context

      context
    end

    def self.default_question_context
      context = Shared::Tag.current_academic_year_value if Rails.module.university?
      context = Shared::Category.find_by(parent_id: nil).name if Rails.module.mooc?
      @question_context ||= context

      context
    end

    def self.context_category(context = default_context)
      Shared::Category.where(name: context).first
    end
  end
end
