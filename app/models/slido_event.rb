class SlidoEvent < ActiveRecord::Base
  belongs_to :category

  validates :uuid,       presence: true
  validates :identifier, presence: true
  validates :name,       presence: true
  validates :url,        presence: true
  validates :starts_at,  presence: true
  validates :ends_at,    presence: true
end
