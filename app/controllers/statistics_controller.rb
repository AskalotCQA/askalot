class StatisticsController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize! :observe, nil

    @questions = Question
    @users     = User.order(:name)

    filter_by_tags
  end

  private

  def filter_by_tags
    return unless params[:tags].present?

    @questions = @questions.tagged_with(params[:tags])

    authors                = Question.tagged_with(params[:tags]).uniq.pluck(:author_id)
    answer_authors         = Answer.joins(:question).where(question_id: @questions).uniq.pluck(:author_id)
    comment_authors        = Comment.where(commentable_type: :Question).joins('INNER JOIN questions ON questions.id = commentable_id').where(commentable_id: @questions).uniq.pluck(:author_id)
    answer_comment_authors = Comment.where(commentable_type: :Answer).joins('INNER JOIN answers ON answers.id = commentable_id INNER JOIN questions ON questions.id = answers.question_id').where(questions: { id: @questions }).uniq.pluck(:author_id)
    voters                 = Vote.where(votable_type: :Question).joins('INNER JOIN questions ON questions.id = votable_id').where(votable_id: @questions).uniq.pluck(:voter_id)
    answer_voters          = Vote.where(votable_type: :Answer).joins('INNER JOIN answers ON answers.id = votable_id INNER JOIN questions ON questions.id = answers.question_id').where(questions: { id: @questions }).uniq.pluck(:voter_id)

    @users = @users.where(id: (authors.to_set + answer_authors + comment_authors + answer_comment_authors + voters + answer_voters).to_a)
  end
end
