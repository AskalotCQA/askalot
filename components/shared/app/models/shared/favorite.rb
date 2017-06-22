module Shared
class Favorite < ActiveRecord::Base
  include Deletable
  include Notifiable

  belongs_to :favorer, class_name: :'Shared::User', counter_cache: true
  belongs_to :question, -> { unscope where: :deleted }, counter_cache: true

  has_many :related_categories, -> { distinct }, through: :question, source: :related_categories

  scope :by, lambda { |user| where(favorer: user) }
  scope :in_context, lambda { |context| includes(:related_categories).where(categories: { id: context }) }

  self.table_name = 'favorites'

  def to_question
    self.question
  end
end
end
