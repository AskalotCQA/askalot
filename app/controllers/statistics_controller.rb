# NOTE(zbell) refactor to use only raw SQL if too slow

class StatisticsController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize! :observe, nil

    @users     = User.order(:name)
    @questions = Question.all
    @answers   = Answer.all

    filter_by_date
    filter_by_tags
  end

  private

  def filter_by_date
    @from = Date.parse(params[:from]) rescue (DateTime.now.change(month: 9, day: 1) - 1.year).to_date
    @to   = Date.parse(params[:to])   rescue (DateTime.now).to_date

    @from, @to = @to, @from if @from > @to
    @from, @to = @from.at_beginning_of_day, @to.at_end_of_day

    params[:from] = @from.strftime '%-d.%-m.%Y'
    params[:to]   = @to.strftime   '%-d.%-m.%Y'

    @questions = @questions.where(created_at: @from..@to)
  end

  def filter_by_tags
    @questions = @questions.tagged_with(params[:tags]).uniq if params[:tags].present?
    @answers   = join_question(Answer, @questions).uniq

    users  = (@questions.pluck(:author_id) + @answers.pluck(:author_id)).to_set
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
