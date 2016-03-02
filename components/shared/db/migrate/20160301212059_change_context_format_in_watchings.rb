class ChangeContextFormatInWatchings < ActiveRecord::Migration
  def change
    remove_column :watchings, :context
    add_column :watchings, :context, :integer
  end
end
