module Shared
class Label < ActiveRecord::Base
  has_many :labelings, dependent: :restrict_with_exception

  has_many :answers, through: :labelings

  validates :value, presence: true

  symbolize :value, in: [:best, :helpful]

  self.table_name = 'labels'
end
end
