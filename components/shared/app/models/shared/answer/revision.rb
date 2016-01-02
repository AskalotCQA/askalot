module Shared
class Answer
  class Revision < ActiveRecord::Base
    include Deletable

    belongs_to :answer
    belongs_to :editor, class_name: :'Shared::User'

    self.table_name = 'answer_revisions'

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
end
