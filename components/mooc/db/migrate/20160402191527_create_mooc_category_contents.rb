class CreateMoocCategoryContents < ActiveRecord::Migration
  def change
    create_table :mooc_category_contents do |t|
      t.references :category, index: true
      t.text :content

      t.timestamps
    end
  end
end
