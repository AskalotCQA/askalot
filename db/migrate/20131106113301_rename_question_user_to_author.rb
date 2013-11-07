class RenameQuestionUserToAuthor < ActiveRecord::Migration
  def self.up
    rename_column :questions, :user_id, :author_id
  end

  def self.down
    rename_column :questions, :author_id, :user_id
  end
end
