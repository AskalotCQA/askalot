class ChangeContextFormatInActivities < ActiveRecord::Migration
  def change
    remove_column :activities, :context
    add_column :activities, :context, :integer
  end
end
