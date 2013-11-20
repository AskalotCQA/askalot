class Label < ActiveRecord::Base
  has_many :labelings

  validates :value, presence: true

  # TODO (smolnar) consider options :in for managing allowed values
  # TODO (zbell) USE :in !
  symbolize :value
end
