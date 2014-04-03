class AddCreatedOnToActivity < ActiveRecord::Migration
  def up
    add_column :activities, :created_on, :date

    Activity.reset_column_information

    Activity.unscoped.each do |activity|
      activity.created_on = activity.created_at.to_date
      activity.save!
    end

    change_column :activities, :created_on, :date, null: false

    add_index :activities, [:created_on, :created_at]
  end

  def down
    remove_index :activities, [:created_on, :created_at]

    remove_column :activities, :created_on
  end
end
