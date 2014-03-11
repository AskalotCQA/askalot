class SetNotNullOnCreatedAtAndUpdatedAt < ActiveRecord::Migration
  def change
    tables = [:answer_revisions, :answers, :categories, :changelogs, :comment_revisions, :comments, :favorites, :followings,
               :labelings, :labels, :notifications, :question_revisions, :questions, :slido_events, :taggings, :users, :votes, :watchings]

    tables.each do |table|
      change_column table, :created_at, :timestamp, null: false
      change_column table, :updated_at, :timestamp, null: false
    end

    change_column :views, :created_at, :timestamp, null: false
  end
end
