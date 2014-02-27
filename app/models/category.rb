class Category < ActiveRecord::Base
  include Notifiable
  include Watchable

  has_many :questions, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: true

  scope :with_slido, -> { where('slido_username is not null') }

  def count
    questions.reload.size
  end
end
