module Shared::Touchable
  extend ActiveSupport::Concern

  included do
    after_save :update_touched_at! if self != Shared::Question
  end

  def update_touched_at!
    return if self.is_a? Shared::Question

    question            = self.to_question
    question.touched_at = self.updated_at unless untouching_attributes_changed?

    question.save!
  end

  private

  def attribute_changed?(column)
    return true if column.to_sym == :touched_at && untouching_attributes_changed?

    super
  end

  def untouching_attributes_changed?
    attributes = [:favorites_count, :votes_count, :views_count, :votes_difference, :votes_lb_wsci_bp]

    (self.changed.map(&:to_sym) & attributes).any?
  end
end
