class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :initiator, null: false
      t.references :subject,   null: false, polymorphic: true

      t.string :action, null: false

      t.timestamps
    end

    add_index :activities, :initiator_id
    add_index :activities, [:subject_id, :subject_type]

    add_index :activities, :action

    add_index :activities, :created_at
  end
end
