class CreateViews < ActiveRecord::Migration
  def change
    create_table :views do |t|
      t.references :question, null: false
      t.references :user,     null: false

      t.datetime :created_at
    end

    add_index :views, :user_id
    add_index :views, :question_id
  end
end
