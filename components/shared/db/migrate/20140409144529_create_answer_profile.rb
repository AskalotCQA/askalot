class CreateAnswerProfile < ActiveRecord::Migration
  def change
    create_table :answer_profiles do |t|
      t.references :answer, null: false

      t.string :property
      t.float  :value
      t.float  :probability
      t.string :source

      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end

    add_index :answer_profiles, :answer_id
  end
end
