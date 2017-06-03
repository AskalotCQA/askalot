class AddPreferedActivityTabToUsers < ActiveRecord::Migration
  def change
    add_column :users, :prefered_activity_tab, :string, default: 'all'
  end
end
