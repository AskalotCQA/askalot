module University
class Group < ActiveRecord::Base
  # TODO (jharinek) consider Authorable
  include Shared::Deletable
  include Shared::Editable

  VISIBILITIES = [:public, :private]

  belongs_to :creator, class_name: :User

  has_many :documents

  validates :title,       presence: true, length: { minimum: 2, maximum: 140 }
  validates :description, presence: true, length: { minimum: 2 }

  validates :visibility, presence: true

  symbolize :visibility, in: VISIBILITIES

  self.table_name = 'groups'
end
end
