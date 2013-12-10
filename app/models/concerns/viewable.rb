module Viewable
  extend ActiveSupport::Concern

  included do
    has_many :views
    has_many :viewers, through: :views, source: :viewer
  end
end
