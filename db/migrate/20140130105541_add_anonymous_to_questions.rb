class AddAnonymousToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :anonymous, :boolean, null: false, default: false
  end
end
