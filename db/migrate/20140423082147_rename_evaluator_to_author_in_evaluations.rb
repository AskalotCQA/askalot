class RenameEvaluatorToAuthorInEvaluations < ActiveRecord::Migration
  def change
    rename_column :evaluations, :evaluator_id, :author_id
  end
end
