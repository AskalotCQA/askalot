module Shared
class Labeling < ActiveRecord::Base
  include Deletable
  include Notifiable

  belongs_to :author, class_name: :'Shared::User'
  belongs_to :answer, -> { unscope where: :deleted }
  belongs_to :label

  scope :by,   lambda { |user| where author: user }
  scope :for,  lambda { |answer| where answer: answer }
  scope :with, lambda { |label| label.is_a?(Label) ? where(label: label) : joins(:label).where(labels: { value: label }) }

  self.table_name = 'labelings'

  def to_question
    self.answer.to_question
  end
end
end
