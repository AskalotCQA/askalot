class AddColorToQuestionTypes < ActiveRecord::Migration
  def change
    add_column :question_types, :color, :string, default: '#000000'
  end
end
