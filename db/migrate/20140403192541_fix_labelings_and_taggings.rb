class FixLabelingsAndTaggings < ActiveRecord::Migration
  def up
    remove_index :labelings, name: 'index_labelings_on_unique_key'
    remove_index :taggings,  name: 'index_taggings_on_unique_key'

    Answer.unscoped.find_each do |answer|
      Labeling.where(deleted: true, answer_id: answer).each do |labeling|
        if Labeling.where(deleted: false, answer_id: answer, label: labeling.label, author: labeling.author).exists?
          labeling.destroy!
        end
      end
    end

    Question.unscoped.find_each do |question|
      Tagging.where(deleted: true, question_id: question).each do |tagging|
        if Tagging.where(deleted: false, question_id: question, tag: tagging.tag, author: tagging.author).exists?
          tagging.destroy!
        end
      end
    end

    add_index :labelings, [:answer_id, :label_id, :author_id], name: 'index_labelings_on_unique_key', unique: true
    add_index :taggings,  [:question_id, :tag_id, :author_id], name: 'index_taggings_on_unique_key',  unique: true
  end
end
