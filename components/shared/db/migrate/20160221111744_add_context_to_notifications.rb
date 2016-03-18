class AddContextToNotifications < ActiveRecord::Migration
  def up
    add_column :notifications, :context, :integer

    ActiveRecord::Base.record_timestamps = false

    Shared::Notification.all.each do |notification|
      year = (now = notification.created_at).month >= 9 ? now.year : (now.year - 1)
      full_tree_name = "#{year}-#{(year + 1).to_s[-2..-1]}"

      notification.context = Shared::Category.find_by(full_tree_name: full_tree_name).id
      notification.save!
    end
  end

  def down
    remove_column :notifications, :context
  end
end