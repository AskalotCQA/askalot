class CreateGroups < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.references :owner, null: false

      t.string :title, null: false, default: ''
      t.string :description

      t.string :visibility, null: false, default: 'public'

      t.boolean    :deleted, null: false, default: false
      t.references :deletor, null: true

      t.timestamps
    end

    add_index :documents, :title
    add_index :documents, :owner_id
    add_index :documents, :deletor_id
  end
end
