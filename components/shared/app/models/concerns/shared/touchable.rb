module Shared::Touchable
  extend ActiveSupport::Concern

  included do
    before_save { self.update_touched_at! if self.is_a? Shared::Question }
    after_save { self.update_touched_at! unless self.is_a? Shared::Question }
  end

  def update_touched_at!
    if self.is_a? Shared::Question
      self.touched_at = Time.now unless untouching_attributes_changed?
    else
      question            = self.to_question
      question.touched_at = self.updated_at unless untouching_attributes_changed?

      question.save!
    end
  end

  private

  def untouching_attributes_changed?
    attributes = [:favorites_count, :votes_count, :views_count, :votes_difference, :votes_lb_wsci_bp, :closed]

    (self.changed.map(&:to_sym) & attributes).any?
  end
end
