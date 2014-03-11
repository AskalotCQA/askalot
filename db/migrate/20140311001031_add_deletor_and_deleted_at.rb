class AddDeletorAndDeletedAt < ActiveRecord::Migration
  def change
    models = [:answers, :questions, :comments, :evaluations, :labelings, :views, :votes]

    models.each do |model|
      add_column model, :deleted_at, :timestamp, default: null
      add_references model, :deletor, index: true
    end
  end
end
