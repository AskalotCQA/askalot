class Group < ActiveRecord::Base
  include Deletable

  VISIBILITIES=[:public, :student_only]

  has_many :documents

  belongs_to :owner, class_name: :User

  validates :title,      presence: true
  validates :visibility, presence: true

  symbolize :visibility, in: VISIBILITIES
end
