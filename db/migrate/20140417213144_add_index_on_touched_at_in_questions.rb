class AddIndexOnTouchedAtInQuestions < ActiveRecord::Migration
  def change
    add_index :questions, :touched_at
  end
end
