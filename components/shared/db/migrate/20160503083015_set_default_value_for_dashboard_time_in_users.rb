class SetDefaultValueForDashboardTimeInUsers < ActiveRecord::Migration
  def change
    execute 'alter table users alter column dashboard_last_sign_in_at set default now()'
  end
end
