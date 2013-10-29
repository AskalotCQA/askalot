class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.references :user,     null: false
      t.references :category, null: false

      t.string :title, null: false
      t.text   :text,  null: false

      t.timestamps
    end

    add_index :questions, :title
    add_index :questions, :user_id
    add_index :questions, :category_id
  end
end
