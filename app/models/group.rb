class Group < ActiveRecord::Base
  VISIBILITIES=[:public, :student_only]

  has_many :documents

  validates :title, presence: true

  validates :visibility, presence: true

  symbolize :visibility, in: VISIBILITIES
end
