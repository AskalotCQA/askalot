class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :title, null: false, default: ''
      t.string :description

      t.string :visibility, null: false, default: 'public'

      t.timestamps
    end

    add_index :groups, :title
  end
end
