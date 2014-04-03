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

  belongs_to :question, -> { deleted_or_not }, counter_cache: true

  has_many :revisions, class_name: :AnswerRevision, dependent: :destroy

  validates :text, presence: true

  scope :by,  lambda { |user| where(author: user) }
  scope :for, lambda { |question| where(question: question) }

  Hash[Label.value_enum].values.each { |label| scope label, -> { labeled_with label } }

  def labeled_with(label)
    labelings.with label
  end

  def labeled_by?(user, label)
    labelings.by(user).with(label).any?
  end

  def toggle_labeling_by!(user, label)
    label = Label.where(value: label).first_or_create! unless label.is_a? Label

    labeling = Labeling.unscoped.find_or_create_by!(author: user, answer: self, label: label)

    if labeling.deleted?
      labeling.unmark_as_deleted!
    else
      labeling.mark_as_deleted_by! user
    end

    labeling
  end

  def best?
    labels.exists? value: :best
  end

  def helpful?
    labels.exists? value: :helpful
  end

  def to_question
    self.question
  end

  private

  def slido_label_with_best!
    return unless author.role == :teacher
    return unless question.author.login.to_sym == :slido
    return unless question.answers.count == 1

    toggle_labeling_by! author, :best
  end
end
