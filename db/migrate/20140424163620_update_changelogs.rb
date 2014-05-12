class UpdateChangelogs < ActiveRecord::Migration
  def change
    change_column :changelogs, :title,   :string, null: true
    change_column :changelogs, :text,    :text,   null: true
    change_column :changelogs, :version, :string, null: false
  end
end
