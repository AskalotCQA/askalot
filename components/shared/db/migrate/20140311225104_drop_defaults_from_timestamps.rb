class DropDefaultsFromTimestamps < ActiveRecord::Migration
  def change
    change_column_default :questions, :touched_at, nil

    change_column_default :tags, :created_at, nil
    change_column_default :tags, :updated_at, nil
  end
end
