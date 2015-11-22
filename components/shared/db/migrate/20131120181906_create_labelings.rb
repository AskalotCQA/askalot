class CreateLabelings < ActiveRecord::Migration
  def change
    create_table :labelings do |t|
      t.references :author, null: false
      t.references :answer, null: false
      t.references :label,  null: false

      t.timestamps
    end

    add_index :labelings, :author_id
    add_index :labelings, :answer_id
    add_index :labelings, :label_id
  end
end
