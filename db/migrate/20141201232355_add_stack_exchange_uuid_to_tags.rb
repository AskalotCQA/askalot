class AddStackExchangeUuidToTags < ActiveRecord::Migration
  def change
    add_column :tags, :stack_exchange_uuid, :integer

    add_index :tags, :stack_exchange_uuid
  end
end
