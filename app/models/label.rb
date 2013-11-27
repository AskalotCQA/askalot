class Label < ActiveRecord::Base
  has_many :labelings

  validates :value, presence: true

  symbolize :value, in: [:best, :helpful, :verified]
end
