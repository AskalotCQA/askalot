class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|

      t.timestamps
    end
  end
end
