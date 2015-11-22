class DropIndexOnUpdatedOnFromActivities < ActiveRecord::Migration
  def change
    remove_index :activities, :updated_on
  end
end
