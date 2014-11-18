class CreateGroupRevisions < ActiveRecord::Migration
  def change
    create_table :group_revisions do |t|
      t.references :group,  null:false
      t.references :editor, null: false

      t.string :title,      null: false
      t.text   :description
      t.string :visibility, null: false, default: :public

      t.timestamps
    end

    add_index :group_revisions, :group_id
    add_index :group_revisions, :editor_id
  end
end
