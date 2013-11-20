class Label < ActiveRecord::Base
  validates :value, presence: true

  # TODO (smolnar) consider options :in for managing allowed values
  symbolize :value
end
