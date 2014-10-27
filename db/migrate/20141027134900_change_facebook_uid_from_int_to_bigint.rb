class ChangeFacebookUidFromIntToBigint < ActiveRecord::Migration
  def up
    change_column :users, :facebook_uid, :bigint
  end

  def down
    change_column :users, :facebook_uid, :integer
  end
end
