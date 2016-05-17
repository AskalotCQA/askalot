class AddAskalotPageUrlToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :askalot_page_url, :string
  end
end
