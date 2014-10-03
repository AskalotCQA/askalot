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

  private

  def attribute_changed?(column)
    attrs = ['favorites_count', 'votes_count', 'views_count', 'votes_difference', 'votes_lb_wsci_bp', ]
    if column == 'touched_at'
      (self.changed & attrs).any? ? (return true) : (return super)
    end

    super
  end
end
