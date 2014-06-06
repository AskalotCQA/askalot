class Document < ActiveRecord::Base
  TYPES=[:chunk, :question]

  belongs_to :group, counter_cache: true

  has_many :questions

  validates :title,         presence: true, length: { maximum: 200 }
  validates :document_type, presence: true

  symbolize :document_type, in: TYPES
end
