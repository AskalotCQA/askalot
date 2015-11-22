class InsertRoot < ActiveRecord::Migration
  def up
    Shared::Category.find_or_create_by!(name: 'root')
  end

  def down
    Shared::Category.find_by(name: 'root').destroy!
  end
end