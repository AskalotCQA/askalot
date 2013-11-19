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

  has_many :questions, foreign_key: :author_id
  has_many :answers,   foreign_key: :author_id

  # TODO (jharinek) gravatar_email - do not allow blank, but needs to be fixed
  # TODO (smolnar) check uniqueness value select in db

  validates :login, format: { with: /\A[A-Za-z0-9_]+\z/ }, presence: true, uniqueness: { case_sensitive: false }
  validates :nick,  format: { with: /\A[A-Za-z0-9_]+\z/ }, presence: true, uniqueness: { case_sensitive: false }

  validates :email,          format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ }, presence: true, uniqueness: { case_sensitive: false }
  validates :gravatar_email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ }, allow_blank: true

  validates :first, format: { with: /\A[A-Z][a-z]*\z/ }, allow_blank: true
  validates :last,  format: { with: /\A[A-Z][a-z]*\z/ }, allow_blank: true

  Social.networks.each do |key, data|
    base = data.placeholder.clone

    base.gsub!(/\A(https?:\/\/)?(www.)?/, '')
    base.gsub!(/[\.\/]/) { |s| '\\' + s }
    base.gsub!('userid', '[0-9]+')
    base.gsub!('username', '[a-zA-Z0-9\.\_\-]+')

    validates key, format: { with: /\A(https?\:\/\/)?(www.)?#{base}\/?\z/ }, allow_blank: true
  end

  def gravatar_email
    (value = read_attribute :gravatar_email).blank? ? email : value
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
