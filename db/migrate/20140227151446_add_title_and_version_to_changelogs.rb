class AddTitleAndVersionToChangelogs < ActiveRecord::Migration
  def change
    add_column :changelogs, :title, :string
    add_column :changelogs, :version, :string

    add_index :changelogs, :version, unique: true
  end
end
