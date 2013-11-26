class Answer < ActiveRecord::Base
  belongs_to :author, class_name: :User
  belongs_to :question

  has_many :labelings
  has_many :labels, through: :labelings

  has_many :watchings, as: :watchable

  has_many :votes, as: :votable

  validates :text, presence: true

  def is_best_answer?
    label_list.include? 'best-answer' 
  end

  def set_best_answer
    label_list.add('best-answer') if !is_checked?
    save
  end
end

