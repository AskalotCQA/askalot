class AddDashboardLastSignInAtToUser < ActiveRecord::Migration
  def up
    add_column :users, :dashboard_last_sign_in_at, :datetime
    update "UPDATE users SET dashboard_last_sign_in_at = last_sign_in_at"
  end

  def down
    remove_column :users, :dashboard_last_sign_in_at
  end
end
