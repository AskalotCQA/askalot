class DropGroupMembers < ActiveRecord::Migration
  def change
    drop_table :group_members
  end
end
