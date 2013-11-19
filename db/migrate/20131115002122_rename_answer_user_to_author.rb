class RenameAnswerUserToAuthor < ActiveRecord::Migration
  def self.up
    rename_column :answers, :user_id, :author_id
  end

  def self.down
    rename_column :answers, :author_id, :user_id
  end
end
