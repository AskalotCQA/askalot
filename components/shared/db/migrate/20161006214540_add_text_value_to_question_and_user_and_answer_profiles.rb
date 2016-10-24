class AddTextValueToQuestionAndUserAndAnswerProfiles < ActiveRecord::Migration
  def change
    add_column :question_profiles, :text_value, :text
    add_column :user_profiles, :text_value, :text
    add_column :answer_profiles, :text_value, :text
  end
end
