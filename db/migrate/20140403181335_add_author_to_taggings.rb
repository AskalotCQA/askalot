class AddAuthorToTaggings < ActiveRecord::Migration
  def change
    add_column :taggings, :author_id, :integer

    Question.unscoped.find_each do |question|
      Tagging.unscoped.where(question_id: question).each do |tagging|
        tagging.update_attributes!(author_id: question.author_id)
      end
    end

    change_column :taggings, :author_id, :integer, null: false
  end
end
