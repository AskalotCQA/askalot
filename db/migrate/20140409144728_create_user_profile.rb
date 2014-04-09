class CreateUserProfile < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.references :user, null: false
      t.references :targetable, null: false, polymorphic: true

      t.string :attribute
      t.float :value
      t.float :probability
      t.string :source

      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end

    add_index :user_profiles, :user_id
    add_index :user_profiles, [:targetable_id, :targetable_type]
  end
end
