class AddTouchedAtToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :touched_at, :datetime, null: false, default: Time.now
  end
end
