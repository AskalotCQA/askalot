class Evaluation
  class Revision < ActiveRecord::Base
    include Deletable

    belongs_to :evaluation
    belongs_to :editor, class_name: :User

    def self.create_revision!(editor, evaluation)
      revision            = Evaluation::Revision.new
      revision.evaluation = evaluation
      revision.editor     = editor
      revision.text       = evaluation.text
      revision.value      = evaluation.value

      revision.save!
      revision
    end
  end
end
