module Shared
class Question
  class Revision < ActiveRecord::Base
    include Deletable

    belongs_to :document
    belongs_to :question
    belongs_to :editor, class_name: :User

    self.table_name = 'question_revisions'

    def self.create_revision!(editor, question)
      revision          = Question::Revision.new
      revision.editor   = editor
      revision.question = question
      revision.category = question.category.name if question.category
      revision.document = question.document      if question.document
      revision.tags     = question.labels.map(&:name)
      revision.title    = question.title
      revision.text     = question.text

      revision.save!
      revision
    end
  end
end
end
