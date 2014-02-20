class StatisticsController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize! :observe, nil

    @questions = Question.all
    @users     = User.order(:name)

    filter_by_date
    filter_by_tags
  end

  private

  def filter_by_date
    params[:from] = (DateTime.now.change(month: 9, day: 1) - 1.year).strftime '%-d.%-m.%Y' unless params[:from].present?
    params[:to]   = (DateTime.now.strftime '%-d.%-m.%Y') unless params[:to].present?

    # TODO(zbell) add filtering
    #@questions = @questions.where(created_at: ..)
  end

  def filter_by_tags
    return unless params[:tags].present?

    @questions = @questions.tagged_with(params[:tags])

    users  = Question.tagged_with(params[:tags]).uniq.pluck(:author_id).to_set
    users += join_question(Answer, @questions).pluck(:author_id)
    users += join_questions(Comment, :commentable, @questions).uniq.pluck(:author_id)
    users += join_questions_through_answers(Comment, :commentable, @questions).pluck(:author_id)
    users += join_questions(Vote, :votable, @questions).uniq.pluck(:voter_id)
    users += join_questions_through_answers(Vote, :votable, @questions).pluck(:voter_id)

    @users = @users.where(id: users.to_a)
  end

  helper_method :join_question, :join_questions, :join_questions_through_answers

  def join_question(relation, questions)
    relation.joins(:question).where(question_id: questions)
  end

  def join_questions(relation, column, questions)
    relation.for(Question).joins("INNER JOIN questions ON questions.id = #{column}_id").where("#{column}_id" => questions).uniq
  end

  def join_questions_through_answers(relation, column, questions)
    relation.for(Answer).joins("INNER JOIN answers ON answers.id = #{column}_id INNER JOIN questions ON questions.id = answers.question_id").where(questions: { id: questions }).uniq
  end
end
