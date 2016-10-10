module Shared::Listable
  extend ActiveSupport::Concern

  included do
    has_many :lists, dependent: :destroy
    has_many :listers, through: :lists, source: :lister

    scope :listed, lambda { joins(:lists).uniq }
    scope :listed_by, lambda { |user| listed.merge(Shared::List.by user) }
    scope :listed_by_others, lambda { listed.where('lister_id != author_id') }
  end

  def listed_by?(user)
    lists.exists? lister: user
  end

  def lists_total
    Shared::List.where(category: self).distinct.count(:lister_id)
  end
end
