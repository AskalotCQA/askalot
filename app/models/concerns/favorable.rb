module Favorable
  extend ActiveSupport::Concern

  included do
    has_many :favorites, dependent: :destroy
    has_many :favorers, through: :favorites, source: :favorer

    scope :favored, lambda { joins(:favorites).uniq }
    scope :favored_by, lambda { |user| favored.merge(Favorite.by user) }
  end

  def favored_by?(user)
    favorites.exists? favorer: user
  end

  def toggle_favoring_by!(user)
    favoring = favorites.unscoped.find_or_initialize_by(favorer: user, question: self)

    favoring.toggle_deleted_by! user

    favoring
  end
end
