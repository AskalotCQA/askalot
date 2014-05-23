class AddCounterCachesToGroups < ActiveRecord::Migration
  def change
    add_counter :groups, :documents
  end
end
