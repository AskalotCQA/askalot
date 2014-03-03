module Touchable
  extend ActiveSupport::Concern

  # TODO(jharinek) experiment 1
  #included do
  #  before_save :touch_touched_at
  #  after_save :update_touched_at!
  #end
  #
  #def update_touched_at!
  #  question = self.to_question
  #
  #  unless question == self
  #    question.touched_at = self.updated_at
  #
  #    question.save!
  #  end
  #end
  #
  #private
  #
  #def touch_touched_at
  #  question = self.to_question
  #
  #  question.touch(:touched_at) if question == self
  #end

  # TODO(jharinek) experiment 2
  #included do
  #  after_touch :update_touched_at!
  #end
  #
  #def update_touched_at!
  #  question = self.to_question
  #
  #  question.touched_at = self.updated_at
  #  question.save!
  #end
end
