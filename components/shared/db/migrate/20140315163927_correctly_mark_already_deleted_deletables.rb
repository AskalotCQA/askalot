class CorrectlyMarkAlreadyDeletedDeletables < ActiveRecord::Migration
  def change
    models = [
      Shared::Answer,
      Shared::Answer::Revision,
      Shared::Comment,
      Shared::Comment::Revision,
      Shared::Evaluation,
      Shared::Favorite,
      Shared::Labeling,
      Shared::Question,
      Shared::Question::Revision,
      Shared::Tagging,
      Shared::View,
      Shared::Vote
    ]

    models.each do |model|
      model.unscoped.where(deleted: true, deleted_at: nil).find_each do |record|
        record.mark_as_deleted_by! record.author, record.updated_at
      end
    end
  end
end
