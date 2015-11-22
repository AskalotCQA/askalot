class UpdatePolymorphicTypes < ActiveRecord::Migration
  @@mappings = {
      'Labeling' => 'Shared::Labeling',
      'Comment' => 'Shared::Comment',
      'View' => 'Shared::View',
      'Favorite' => 'Shared::Favorite',
      'Evaluation' => 'Shared::Evaluation',
      'Following' => 'Shared::Following',
      'Watching' => 'Shared::Watching',
      'Category' => 'Shared::Category',
      'Vote' => 'Shared::Vote',
      'Tag' => 'Shared::Tag',
      'Tagging' => 'Shared::Tagging',
      'Reputation' => 'Shared::Reputation',
      'Answer' => 'Shared::Answer',
      'Question' => 'Shared::Question'
  }

  @@columns = {
      'activities' => 'resource_type',
      'comments' => 'commentable_type',
      'evaluations' => 'evaluable_type',
      'notifications' => 'resource_type',
      'user_profiles' => 'targetable_type',
      'votes' => 'votable_type',
      'watchings' => 'watchable_type',
  }

  def up
    @@columns.each do |table, column|
      @@mappings.each do |before, after|
        execute "UPDATE #{table} SET #{column} = '#{after}' WHERE #{column} = '#{before}'"
      end
    end
  end

  def down
    @@columns.each do |table, column|
      @@mappings.each do |before, after|
        execute "UPDATE #{table} SET #{column} = '#{before}' WHERE #{column} = '#{after}'"
      end
    end
  end
end
