class AddSecondaryGravatarEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gravatar_email, :string, null: true, default: nil
  end
end
