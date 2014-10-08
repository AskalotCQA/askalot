class Document < ActiveRecord::Base
  include Deletable
  include Editable

  TYPES = [:text]

  belongs_to :group, counter_cache: true

  has_many :questions

  validates :title,   presence: true, length: { minimum: 2, maximum: 140 }
  validates :content, presence: true, length: { minimum: 2 }

  validates :document_type, presence: true

  symbolize :document_type, in: TYPES
end
