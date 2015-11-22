class AddClosedToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :closed, :boolean, index: true, null: false, default: false
    add_reference :questions, :closer, null: true, index: true
    add_column :questions, :closed_at, :timestamp
  end
end
