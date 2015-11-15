module University
class SlidoEvent < ActiveRecord::Base
  belongs_to :category

  validates :uuid,       presence: true
  validates :identifier, presence: true
  validates :name,       presence: true
  validates :url,        presence: true
  validates :started_at, presence: true
  validates :ended_at,   presence: true

  self.table_name = 'slido_events'
end
end
