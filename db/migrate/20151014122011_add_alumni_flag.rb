class AddAlumniFlag < ActiveRecord::Migration
  def change
    add_column :users, :alumni, :boolean, default: true, null: false
  end
end
