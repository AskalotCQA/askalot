class ForceNonNullsInActivities < ActiveRecord::Migration
  def change
    change_column :activities, :created_at, :datetime, null: false
    change_column :activities, :updated_at, :datetime, null: false
  end
end
