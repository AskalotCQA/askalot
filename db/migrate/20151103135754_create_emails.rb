class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.references :user
      t.text :subject
      t.text :body
      t.boolean :status
      t.boolean :send_html_email

      t.timestamps
    end
  end
end
