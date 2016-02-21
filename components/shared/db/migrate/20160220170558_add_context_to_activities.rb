class AddContextToActivities < ActiveRecord::Migration
  def up
    add_column :activities, :context, :string

    Shared::Activity.unscoped.all.each do |activity|
      activity.context = Shared::ApplicationHelper.current_context

      activity.save!
    end
  end

  def down
    remove_column :activities, :context
  end
end
