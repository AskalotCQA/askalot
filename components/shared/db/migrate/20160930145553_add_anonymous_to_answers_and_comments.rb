class AddAnonymousToAnswersAndComments < ActiveRecord::Migration
  def change
    add_column :answers, :anonymous, :boolean, default: false
    add_column :comments, :anonymous, :boolean, default: false
  end
end
