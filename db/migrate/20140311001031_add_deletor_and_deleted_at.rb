class AddDeletorAndDeletedAt < ActiveRecord::Migration
  def change
    models = [:answers, :answer_revisions, :comments, :comment_revisions, :evaluations, :favorites,
              :labelings, :questions, :question_revisions, :views, :votes]

    models.each do |model|
      add_column model, :deleted_at, :timestamp, default: null

      add_references model, :deletor, index: true
    end
  end
end
