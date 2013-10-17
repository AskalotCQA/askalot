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
  validates :nick, presence: true

  def login=(value)
    write_attribute(:login, value.downcase)

    self.nick ||= login
  end

  def self.create_without_confirmation!(attributes)
    user = User.new(attributes)

    user.skip_confirmation!
    user.save!
    user
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    login      = conditions.delete(:login)

    return where(conditions).first unless login

    where(conditions).where(["login = :value OR email = :value", { value: login.downcase }]).first
  end

  protected

  def password_required?
    ais_login.nil? ? super : false
  end
end
