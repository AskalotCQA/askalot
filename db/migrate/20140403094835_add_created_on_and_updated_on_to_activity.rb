class AddCreatedOnAndUpdatedOnToActivity < ActiveRecord::Migration
  def up
    add_column :activities, :created_on, :date
    add_column :activities, :updated_on, :date

    Activity.reset_column_information

    Activity.unscoped.each do |activity|
      activity.created_on = activity.created_at.to_date
      activity.updated_on = activity.updated_at.to_date
      activity.save!
    end

    change_column :activities, :created_on, :date, null: false
    change_column :activities, :updated_on, :date, null: false

    add_index :activities, :created_on
    add_index :activities, :updated_on
  end

  def down
    remove_index :activities, :updated_on
    remove_index :activities, :created_on

    remove_column :activities, :created_on
    remove_column :activities, :updated_on
  end
end
