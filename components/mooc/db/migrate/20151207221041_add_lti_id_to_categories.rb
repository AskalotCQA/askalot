class AddLtiIdToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :lti_id, :string, default: nil
    add_index :categories, :lti_id
  end
end
