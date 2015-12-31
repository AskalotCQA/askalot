class EditRequiredUserFields < ActiveRecord::Migration
  def change
    change_column :users, :encrypted_password, :string, :null => true, default: nil
  end
end
