class AddContextToActivities < ActiveRecord::Migration
  def up
    add_column :activities, :context, :integer

    ActiveRecord::Base.disable_timestamps

    Shared::Activity.all.each do |activity|
      year = (now = activity.created_at).month >= 9 ? now.year : (now.year - 1)
      full_tree_name = "#{year}-#{(year + 1).to_s[-2..-1]}"

      activity.context = Shared::Category.find_by(full_tree_name: full_tree_name).id
      activity.save!
    end
  end

  def down
    remove_column :activities, :context
  end
end