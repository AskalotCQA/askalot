class AddAuthorToTaggings < ActiveRecord::Migration
  def change
    add_column :taggings, :author_id, :integer

    Question.unscoped.find_each do |question|
      question.taggings.unscoped.each do |tagging|
        tagging.update_attributes!(author_id: question.author_id)
      end
    end

    change_column :taggings, :author_id, :integer, null: false
  end
end
