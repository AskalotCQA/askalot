class RenameQuestionUserToAuthor < ActiveRecord::Migration
  def up
    rename_column :questions, :user_id, :author_id
  end

  def down
    rename_column :questions, :author_id, :user_id
  end
end
