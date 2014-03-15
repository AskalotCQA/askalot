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
      model.where({deleted_at: nil, deleted: true}).find_all.each do |record|
        record.deleted_at = record.updated_at
        record.deletor_id = record.author_id

        record.save!
      end
    end
  end
end
