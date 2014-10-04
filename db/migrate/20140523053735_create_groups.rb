class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.references :owner, null: false

      t.string :title, null: false, default: ''
      t.string :description

      # TODO empty string?
      t.string :visibility, null: false, default: :public

      t.boolean    :deleted, null: false, default: false
      t.references :deletor, null: true
      t.timestamp  :deleted_at

      t.timestamps
    end

    add_index :groups, :title
    add_index :groups, :owner_id
    add_index :groups, :deletor_id
  end
end
