# NOTE(zbell) refactor to use only raw SQL if too slow

module Shared
class StatisticsController < ApplicationController
  before_action :authenticate_user!

  default_tab :overall, only: :index

  def index
    authorize! :observe, nil

    now = DateTime.now

    @from = Date.parse(params[:from]) rescue now.change(month: 9, day: 1).instance_eval { |from| now.month < 9 ? (from - 1.year) : from }.to_date
    @to   = Date.parse(params[:to])   rescue now.to_date

    @from, @to = @to, @from if @from > @to
    @from, @to = @from.at_beginning_of_day, @to.at_end_of_day

    params[:from] = @from.strftime '%-d.%-m.%Y'
    params[:to]   = @to.strftime   '%-d.%-m.%Y'

    params[:to]   = @to.strftime   '%-d.%-m.%Y'

    if params[:category].present?
      @users     = Shared::User.order(:name)
      @questions = Shared::Question
      @answers   = Shared::Answer

      filter_by_date
      filter_by_category
    end
  end

  private

  def filter_by_date
    @questions = @questions.where(created_at: @from..@to)
  end

  def filter_by_category
    @questions = @questions.in_context(params[:category])
    @answers   = join_question(Shared::Answer, @questions).uniq

    users  = (@questions.pluck(:author_id) + @answers.pluck(:author_id)).to_set
    users += join_questions(Shared::Comment, :commentable, @questions).uniq.pluck(:author_id)
    users += join_questions_through_answers(Shared::Comment, :commentable, @questions).pluck(:author_id)
    users += join_questions(Shared::Vote, :votable, @questions).uniq.pluck(:voter_id)
    users += join_questions_through_answers(Shared::Vote, :votable, @questions).pluck(:voter_id)

    @users = @users.where(id: users.to_a)
  end

  helper_method :join_question, :join_questions, :join_questions_through_answers

  def join_question(relation, questions)
    relation.joins(:question).where(question_id: questions.map(&:id))
  end

  def join_questions(relation, column, questions)
    relation.for(Shared::Question).joins("INNER JOIN questions ON questions.id = #{column}_id").where("#{column}_id" => questions.map(&:id)).uniq
  end

  def join_questions_through_answers(relation, column, questions)
    relation.for(Shared::Answer).joins("INNER JOIN answers ON answers.id = #{column}_id INNER JOIN questions ON questions.id = answers.question_id").where(questions: { id: questions.map(&:id) }).uniq
  end
end
end
