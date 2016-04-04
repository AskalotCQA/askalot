class UpdateAskableDefaultFalseCategory < ActiveRecord::Migration
  def change
    change_column :categories, :askable, :boolean, :default => true
  end
end
