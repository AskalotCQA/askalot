module University::Favorable
  extend ActiveSupport::Concern

  included do
    has_many :favorites, dependent: :destroy
    has_many :favorers, through: :favorites, source: :favorer

    scope :favored, lambda { joins(:favorites).uniq }
    scope :favored_by, lambda { |user| favored.merge(University::Favorite.by user) }
  end

  def favored_by?(user)
    favorites.exists? favorer: user
  end

  def toggle_favoring_by!(user)
    favorites.deleted_or_new(favorer: user, question: self).toggle_deleted_by! user
  end
end
