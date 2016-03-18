class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.references :user,     null: false
      t.references :question, null: false

      t.text :text, null: false

      t.timestamps
    end

    add_index :answers, :user_id
    add_index :answers, :question_id
  end
end
