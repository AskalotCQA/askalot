module Viewable
  extend ActiveSupport::Concern

  included do
    has_many :views
    has_many :viewers, through: :views, source: :viewer

    scope :viewed, lambda { joins(:views).uniq }
    scope :viewed_by, lambda { |user| viewed.merge(View.by user) }
  end

  def viewed_by?(user)
    views.exists? viewer: user
  end

  def views_total
    View.where(question: self).distinct.count(:viewer_id)
  end
end
