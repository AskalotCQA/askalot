class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.references :creator, null: false

      t.string :title, null: false
      t.text   :description

      t.string :visibility, null: false, default: :public

      t.boolean    :deleted, null: false, default: false
      t.references :deletor, null: true
      t.timestamp  :deleted_at

      t.integer :documents_count, null:false, default: 0

      t.timestamps
    end

    add_index :groups, :title
    add_index :groups, :creator_id
    add_index :groups, :deletor_id
  end
end
