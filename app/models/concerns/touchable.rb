module Touchable
  extend ActiveSupport::Concern

  included do
    before_save :touch_touched_at
    after_save  :update_touched_at!
  end

  def update_touched_at!
    question = self.to_question

    unless question == self
      question.touched_at = self.updated_at

      question.save!
    end
  end

  private

  def touch_touched_at
    question = self.to_question

    question == self && question.new_record? ? question.touch(:touched_at) : question.touched_at = DateTime.now
  end
end
