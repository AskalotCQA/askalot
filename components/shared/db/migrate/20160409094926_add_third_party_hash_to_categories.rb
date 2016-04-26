class AddThirdPartyHashToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :third_party_hash, :string
  end
end
