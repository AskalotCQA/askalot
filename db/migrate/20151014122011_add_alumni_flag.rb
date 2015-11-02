class AddAlumniFlag < ActiveRecord::Migration
  def change
    add_column :users, :alumni, :boolean, default: false, null: false
  end
end
