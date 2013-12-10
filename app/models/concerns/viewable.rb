module Viewable
  extend ActiveSupport::Concern

  included do
    has_many :views
    has_many :viewers, through: :views, source: :viewer
  end

  def total_views
    View.where(question: self).distinct.count(:viewer_id)
  end
end
