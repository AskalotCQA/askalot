module Touchable
  extend ActiveSupport::Concern

  included do
    after_save   :update_touched_at!
  end

  def update_touched_at!
    question = self.to_question

    unless question == self
      question.touched_at = self.updated_at

      question.save!
    end
  end
end
