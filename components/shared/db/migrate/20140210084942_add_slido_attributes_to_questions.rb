class AddSlidoAttributesToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :slido_uuid,       :integer
    add_column :questions, :slido_event_uuid, :integer
  end
end
