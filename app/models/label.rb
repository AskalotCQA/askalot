class Label < ActiveRecord::Base
  has_many :labelings, dependent: :restrict_with_exception

  validates :value, presence: true

  symbolize :value, in: [:best, :helpful, :verified]
end
