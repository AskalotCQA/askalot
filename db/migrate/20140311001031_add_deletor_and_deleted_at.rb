class AddDeletorAndDeletedAt < ActiveRecord::Migration
  def change
    models = [:answers, :answer_revisions, :comments, :comment_revisions, :evaluations, :favorites,
              :labelings, :questions, :question_revisions, :taggings, :views, :votes]

    models.each do |model|
      add_column model, :deleted_at, :timestamp

      add_reference model, :deletor, null: true, index: true
    end
  end
end
