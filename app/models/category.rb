class Category < ActiveRecord::Base
  include Watchable

  has_many :questions

  validates :name, presence: true, uniqueness: true

  scope :with_slido, -> { where('slido_username is not null') }

  def count
    questions.size
  end
end
