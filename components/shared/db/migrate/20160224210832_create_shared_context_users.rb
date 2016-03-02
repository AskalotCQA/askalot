class CreateSharedContextUsers < ActiveRecord::Migration
  def change
    create_table :context_users do |t|
      t.references :user, null: false
      t.string :context

      t.timestamps
    end

    add_index :context_users, :user_id
  end
end
