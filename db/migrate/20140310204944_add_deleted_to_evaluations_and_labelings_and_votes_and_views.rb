class AddDeletedToVotesAndEvaluationsAndViews < ActiveRecord::Migration
  def change
    models = [:answer_revisions, :comment_revisions, :evaluations, :favorites,
              :labelings, :question_revisions, :taggings, :views, :votes]

    models.each do |model|
      add_column model, :deleted, :boolean, null: false, default: false

      add_index model, :deleted
    end
  end
end
