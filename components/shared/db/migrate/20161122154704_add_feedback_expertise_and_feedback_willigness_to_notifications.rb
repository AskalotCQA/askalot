class AddFeedbackExpertiseAndFeedbackWillignessToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :feedback_expertise, :integer
    add_column :notifications, :feedback_willigness, :integer
  end
end
