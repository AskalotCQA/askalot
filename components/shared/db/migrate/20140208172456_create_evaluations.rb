class CreateEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.references :evaluator, null: false
      t.references :evaluable, null: false, polymorphic: true

      t.text    :text
      t.integer :value, null: false

      t.timestamps
    end

    add_index :evaluations, :evaluator_id
    add_index :evaluations, [:evaluable_id, :evaluable_type]
  end
end
