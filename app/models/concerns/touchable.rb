module Touchable
  extend ActiveSupport::Concern

  included do
    after_save :update_touched_at! if self != Question
  end

  def update_touched_at!
    return if self.is_a? Question

    question            = self.to_question
    question.touched_at = self.updated_at

    question.save!
  end
end
