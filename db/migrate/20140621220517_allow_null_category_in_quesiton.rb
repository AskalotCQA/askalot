class AllowNullCategoryInQuesiton < ActiveRecord::Migration
  def change
    change_column :questions, :category_id, :integer, null: true
  end
end
