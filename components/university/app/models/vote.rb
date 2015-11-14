class Vote < ActiveRecord::Base
  include Deletable
  include Notifiable

  belongs_to :voter, class_name: :User, counter_cache: true
  belongs_to :votable, polymorphic: true, counter_cache: true

  scope :by,  lambda { |user| where(voter: user) }
  scope :for, lambda { |model| where(votable_type: model.to_s.classify) }

  scope :positive, lambda { where(positive: true) }
  scope :negative, lambda { where(positive: false) }

  validates :voter, presence: true, unless: :stack_exchange_uuid?
  validates :stack_exchange_uuid, presence: true, unless: :voter_id?

  def to_question
    self.votable.to_question
  end
end
