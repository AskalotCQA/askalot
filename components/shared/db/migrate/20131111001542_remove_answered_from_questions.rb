class RemoveAnsweredFromQuestions < ActiveRecord::Migration
  def change
    remove_column :questions, :answered, :boolean
  end
end
