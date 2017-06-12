class AddMissingIndexes < ActiveRecord::Migration
  def change
    commit_db_transaction
    add_index :categories_questions, [:category_id], algorithm: :concurrently
    add_index :users, :send_email_notifications
  end
end
