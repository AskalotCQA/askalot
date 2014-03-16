class AddDeletorAndDeletedAtValuesToDeletables < ActiveRecord::Migration
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
        record.deletor_id = record.author_id
        record.deleted_at = record.updated_at

        record.save!
      end
    end
  end
end
