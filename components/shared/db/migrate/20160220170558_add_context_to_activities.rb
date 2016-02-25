class AddContextToActivities < ActiveRecord::Migration
  def up
    add_column :activities, :context, :string

    Shared::Activity.unscoped.find_each do |activity|
      activity.context = Shared::Context::Manager.current_context

      activity.save!
    end
  end

  def down
    remove_column :activities, :context
  end
end
