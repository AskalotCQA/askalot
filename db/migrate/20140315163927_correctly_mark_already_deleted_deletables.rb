class CorrectlyMarkAlreadyDeletedDeletables < ActiveRecord::Migration
  def change
    models = [
      Answer,
      AnswerRevision,
      Comment,
      CommentRevision,
      Evaluation,
      Favorite,
      Labeling,
      Question,
      QuestionRevision,
      Tagging,
      View,
      Vote
    ]

    models.each do |model|
      model.where(deleted: true, deleted_at: nil).find_each do |record|
        record.mark_as_deleted_by! record.author, record.updated_at
      end
    end
  end
end
