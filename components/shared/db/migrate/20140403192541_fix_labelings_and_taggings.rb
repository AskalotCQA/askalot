class FixLabelingsAndTaggings < ActiveRecord::Migration
  def up
    remove_index :labelings, name: 'index_labelings_on_unique_key'
    remove_index :taggings,  name: 'index_taggings_on_unique_key'

    Shared::Answer.unscoped.find_each do |answer|
      Shared::Labeling.unscoped.where(deleted: true, answer_id: answer).each do |labeling|
        if Shared::Labeling.unscoped.where(deleted: false, answer_id: answer, label: labeling.label, author: labeling.author).exists?
          labeling.destroy!
        end
      end
    end

    Shared::Question.unscoped.find_each do |question|
      Shared::Tagging.unscoped.where(deleted: true, question_id: question).each do |tagging|
        if Shared::Tagging.unscoped.where(deleted: false, question_id: question, tag: tagging.tag, author: tagging.author).exists?
          tagging.destroy!
        end
      end
    end

    add_index :labelings, [:answer_id, :label_id, :author_id], name: 'index_labelings_on_unique_key', unique: true
    add_index :taggings,  [:question_id, :tag_id, :author_id], name: 'index_taggings_on_unique_key',  unique: true
  end

  def down
  end
end
