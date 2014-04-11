class CreateQuestionProfile < ActiveRecord::Migration
  def change
    create_table :question_profiles do |t|
      t.references :question, null: false

      t.string :property
      t.float  :value
      t.float  :probability
      t.string :source

      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end

    add_index :question_profiles, :question_id
  end
end
