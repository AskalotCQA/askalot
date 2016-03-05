class ChangeContextFormatInActivities < ActiveRecord::Migration
  def up
    remove_column :activities, :context
    add_column :activities, :context, :integer

    context = Shared::Context::Manager.current_context

    Shared::Activity.unscoped.find_each do |activity|
      activity.context = context

      activity.save!
    end
  end

  def down
    remove_column :activities, :context
    add_column :activities, :context, :string
  end
end
