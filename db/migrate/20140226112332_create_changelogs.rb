class CreateChangelogs < ActiveRecord::Migration
  def change
    create_table :changelogs do |t|
      t.text :text, null: false

      t.timestamps
    end

    add_index :changelogs, :created_at
  end
end
