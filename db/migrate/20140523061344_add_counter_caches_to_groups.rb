class AddCounterCachesToGroups < ActiveRecord::Migration
  def change
    add_counter :documents, :documents
  end
end
