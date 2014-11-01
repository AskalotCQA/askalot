class Group < ActiveRecord::Base
  include Authorable
  include Deletable
  include Editable

  VISIBILITIES = [:public, :private]

  has_many :documents

  belongs_to :author, class_name: :User

  validates :title,       presence: true, length: { minimum: 2, maximum: 140 }
  validates :description, presence: true, length: { minimum: 2 }

  validates :visibility, presence: true

  symbolize :visibility, in: VISIBILITIES
end
