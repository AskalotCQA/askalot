class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :recipient,  null: false
      t.references :initiator,  null: false
      t.references :notifiable, null: false, polymorphic: true

      t.string  :action, null: false
      t.boolean :unread, null: false, default: true

      t.timestamps
    end

    add_index :notifications, :recipient_id
    add_index :notifications, :initiator_id
    add_index :notifications, [:notifiable_id, :notifiable_type]

    add_index :notifications, :action
    add_index :notifications, :unread

    add_index :notifications, :created_at
  end
end
