class AddStackExchangeUuidsToVotesAndFavoritesAndLabelings < ActiveRecord::Migration
  def change
    add_column :votes,     :stack_exchange_uuid, :integer
    add_column :favorites, :stack_exchange_uuid, :integer
    add_column :labelings, :stack_exchange_uuid, :integer

    add_index :votes,     :stack_exchange_uuid, unique: true
    add_index :favorites, :stack_exchange_uuid, unique: true
    add_index :labelings, :stack_exchange_uuid, unique: true
  end
end
