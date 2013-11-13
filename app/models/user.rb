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
  validates :nick, format: { with: /\A[a-z0-9_]+\z/ }, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/}, presence: true, uniqueness: { case_sensitive: false }
  validates :gravatar_email, format: { with: /\A\z|\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ }
  validates :first, format: { with: /\A[A-Z][a-z]*\z/ }
  validates :last, format: { with: /\A[A-Z][a-z]*\z/ }
  validates :facebook, format: { with: /\A\z|\A(http:\/\/)?(www.)?facebook.com\/[A-Za-z._\-]+\z/ }
  validates :twitter, format: { with: /\A\z|\A(http:\/\/)?(www.)?twitter.com\/[A-Za-z._\-]+\z/ }
  validates :linkedin, format: { with: /\A\z|\A(http:\/\/)?(www.)?linkedin.com\/in\/[A-Za-z._\-]+\z/ }

  # TODO (zbell) add missing validations!

  def gravatar_email
    read_attribute(:gravatar_email) || email
  end

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

  def name
    "#{first} #{middle} #{last}".squeeze(' ')
  end

  def can_destroy?
    false
  end

  protected

  def password_required?
    ais_login.nil? ? super : false
  end
end
