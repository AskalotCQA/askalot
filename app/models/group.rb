class Group < ActiveRecord::Base
  # TODO (jharinek) consider Authorable
  include Deletable
  include Editable

  VISIBILITIES = [:public, :private]

  has_many :documents

  belongs_to :creator, class_name: :User

  validates :title,       presence: true, length: { minimum: 2, maximum: 140 }
  validates :description, presence: true, length: { minimum: 2 }

  validates :visibility, presence: true

  symbolize :visibility, in: VISIBILITIES
end
