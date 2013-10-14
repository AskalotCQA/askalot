class User < ActiveRecord::Base
  devise :database_authenticatable,
         :confirmable,
         :lockable,
         :recoverable,
         :registerable,
         :rememberable,
         :trackable,
         :validatable,

         authentication_keys: [:login]

  # TODO (smolnar) check uniqueness value select in db
  validates :login, format: { with: /\A[a-z0-9_]+\z/ }, presence: true, uniqueness: { case_sensitive: false }

  before_save do
    self.login = login.downcase
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    login      = conditions.delete(:login)

    if login
      where(conditions).where(["login = :value OR email = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end
end
