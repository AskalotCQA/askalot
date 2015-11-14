class Answer < ActiveRecord::Base
  include Authorable
  include Commentable
  include Deletable
  include Editable
  include Evaluable
  include Labelable
  include Notifiable
  include Touchable
  include Votable

  after_create :slido_label_with_best!

  belongs_to :question, -> { unscope where: :deleted }, counter_cache: true

  has_many :profiles,  class_name: :'Answer::Profile',  dependent: :destroy
  has_many :revisions, class_name: :'Answer::Revision', dependent: :destroy

  validates :text, presence: true

  scope :by,  lambda { |user| where(author: user) }
  scope :for, lambda { |question| where(question: question) }

  Hash[Label.value_enum].values.each { |label| scope label, -> { labeled_with label } }

  def best?
    labels.exists? value: :best
  end

  def helpful?
    labels.exists? value: :helpful
  end

  def to_question
    self.question
  end

  def reputation
    self.profiles.for('reputation').first_or_create do |p|
      p.property    = :reputation
      p.source      = :reputation
      p.value       = 0
      p.probability = 0
    end
  end

  private

  def slido_label_with_best!
    return unless author.role == :teacher
    return unless question.author.login.to_sym == :slido
    return unless question.answers.count == 1

    toggle_labeling_by! author, :best
  end
end
