class AddIndexToAnonymousFlag < ActiveRecord::Migration
  def change
    add_index :activities,    :anonymous
    add_index :notifications, :anonymous
    add_index :questions,     :anonymous
  end
end
