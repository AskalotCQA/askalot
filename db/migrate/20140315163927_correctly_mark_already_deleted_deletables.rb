class CorrectlyMarkAlreadyDeletedDeletables < ActiveRecord::Migration
  def change
    models = [
      Answer,
      Answer::Revision,
      Comment,
      Comment::Revision,
      Evaluation,
      Favorite,
      Labeling,
      Question,
      Question::Revision,
      Tagging,
      View,
      Vote
    ]

    models.each do |model|
      model.unscoped.where(deleted: true, deleted_at: nil).find_each do |record|
        record.mark_as_deleted_by! record.author, record.updated_at
      end
    end
  end
end
