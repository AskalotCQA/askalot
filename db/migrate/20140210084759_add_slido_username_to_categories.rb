class AddSlidoUsernameToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :slido_username, :string
  end
end
