class CreateCategoriesQuestions < ActiveRecord::Migration
  def change
    create_table :categories_questions do |t|
      t.references :question, null: false
      t.references :category, null: false
      t.boolean :shared, default: false

      t.timestamps
    end

    add_index :categories_questions, :question_id
    add_index :categories_questions, :category_id
  end
end
