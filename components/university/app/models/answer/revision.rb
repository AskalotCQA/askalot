class Answer
  class Revision < ActiveRecord::Base
    include Deletable

    belongs_to :answer
    belongs_to :editor, class_name: :User

    def self.create_revision!(editor, answer)
      revision        = Answer::Revision.new
      revision.editor = editor
      revision.answer = answer
      revision.text   = answer.text

      revision.save!
      revision
    end
  end
end
