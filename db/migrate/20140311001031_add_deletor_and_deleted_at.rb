class AddDeletorAndDeletedAt < ActiveRecord::Migration
  def change

    models = [:answers, :questions, :comments, :evaluations, :labelings, :views, :votes]

    models.each do |model|
      add_column model,  :deleted_at, :timestamp, default: null
      add_column model,  :deletor_id, :integer

      add_index  model,  :deletor_id
    end
  end
end
