class CreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.string :login, null: false

      # Authenticatable
      t.string :email,              null: false, default: ''
      t.string :encrypted_password, null: false, default: ''

      # Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email

      # Lockable
      t.integer  :failed_attempts, default: 0, null: false # only if lock strategy is :failed_attempts
      t.string   :unlock_token                             # only if unlock strategy is :email or :both
      t.datetime :locked_at

      # Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      # Rememberable
      t.datetime :remember_created_at

      # Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.string   :current_sign_in_ip
      t.datetime :last_sign_in_at
      t.string   :last_sign_in_ip

      t.timestamps
    end

    add_index :users, :login,                unique: true
    add_index :users, :email,                unique: true
    add_index :users, :confirmation_token,   unique: true
    add_index :users, :unlock_token,         unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
