class AddDuplicateIdsToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :stack_exchange_duplicate, :boolean
    add_column :questions, :stack_exchange_questions_uuids, :integer, array: true
  end
end
