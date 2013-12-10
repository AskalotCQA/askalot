module Favorable
  extend ActiveSupport::Concern

  included do
    has_many :favorites
    has_many :favorers, through: :favorites, source: :favorer
  end

  def favored_by?(user)
    favorites.exists? favorer: user
  end

  def toggle_favoring_by!(user)
    return Favorite.create! favorer: user, question: self unless favored_by?(user)

    Favorite.where(favorer: user, question: self).first.destroy

    self
  end
end
