class CreateQuestionType < ActiveRecord::Migration
  def change
    create_table :question_types do |t|
      t.string :mode
      t.string :icon
      t.string :name
      t.string :description

      t.timestamps
    end

    add_reference :questions, :question_type, index: true, foreign_key: true
  end
end
