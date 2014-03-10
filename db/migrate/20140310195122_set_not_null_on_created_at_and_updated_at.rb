class SetNotNullOnCreatedAtAndUpdatedAt < ActiveRecord::Migration
  def change
    columns = [:answer_revisions, :answers, :categories, :changelogs, :comment_revisions, :comments, :favorites, :followings,
               :labelings, :labels, :notifications, :question_revisions, :questions, :slido_events, :taggings, :users, :votes, :watchings]

    columns.each do |column|
      change_column column, :created_at, :timestamp, null: false
      change_column column, :updated_at, :timestamp, null: false
    end

    change_column :views, :created_at, :timestamp, null: false
  end
end
