class AddSlidoEventPrefixToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :slido_event_prefix, :string
  end
end
