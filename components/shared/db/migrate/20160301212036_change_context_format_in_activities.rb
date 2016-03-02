class ChangeContextFormatInActivities < ActiveRecord::Migration
  def up
    remove_column :activities, :context
    add_column :activities, :context, :integer
  end

  def down
    remove_column :activities, :context
    add_column :activities, :context, :string
  end
end
