class AddStackExchangeIds < ActiveRecord::Migration
  def change
    add_column :users,     :stack_exchange_uuid, :integer
    add_column :questions, :stack_exchange_uuid, :integer
    add_column :answers,   :stack_exchange_uuid, :integer
    add_column :comments,  :stack_exchange_uuid, :integer

    add_index :users,     :stack_exchange_uuid, unique: true
    add_index :questions, :stack_exchange_uuid, unique: true
    add_index :answers,   :stack_exchange_uuid, unique: true
    add_index :comments,  :stack_exchange_uuid, unique: true
  end
end
