class RenameAnswerUserToAuthor < ActiveRecord::Migration
  def change
    rename_column :answers, :user_id, :author_id
  end
end
