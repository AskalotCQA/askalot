class ChangeContextFormatInContextUsers < ActiveRecord::Migration
  def up
    remove_column :context_users, :context
    add_column :context_users, :context_id, :integer
  end

  def down
    remove_column :context_users, :context_id
    add_column :context_users, :context, :string
  end
end
