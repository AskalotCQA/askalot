class User < ActiveRecord::Base
  devise :confirmable,
         :database_authenticatable,
         :recoverable,
         :registerable,
         :rememberable,
         :validatable

  validates :login, presence: true
end
