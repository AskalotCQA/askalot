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

  has_many :favorites
  has_many :favored_questions, through: :favorites, class_name: :Question

  has_many :answers,   foreign_key: :author_id

  has_many :labelings
  has_many :labels, through: :labelings, foreign_key: :author_id

  has_many :followings
  has_many :followers, through: :followings, class_name: :User, foreign_key: :follower_id
  has_many :followees, through: :followings, class_name: :User, foreign_key: :followee_id

  has_many :watchings, foreign_key: :watcher_id

  has_many :votes, foreign_key: :voter_id

  # TODO (jharinek) gravatar_email - do not allow blank, but needs to be fixed
  # TODO (smolnar) check uniqueness value select in db

  validates :login, format: { with: /\A[A-Za-z0-9_]+\z/ }, presence: true, uniqueness: { case_sensitive: false }
  validates :nick,  format: { with: /\A[A-Za-z0-9_]+\z/ }, presence: true, uniqueness: { case_sensitive: false }

  validates :email,          format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ }, presence: true, uniqueness: { case_sensitive: false }
  validates :gravatar_email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ }, allow_blank: true

  validates :first, format: { with: /\A\p{Lu}\p{Ll}*\z/u }, allow_blank: true
  validates :last,  format: { with: /\A\p{Lu}\p{Ll}*\z/u }, allow_blank: true

  Social.networks.each do |key, network|
    validates key, format: { with: network.regexp }, allow_blank: true
  end

  def login=(value)
    write_attribute(:login, value.downcase)

    self.nick ||= login
  end

  def name
    "#{first} #{middle} #{last}".squeeze(' ').strip
  end

  def can_destroy?
    false
  end

  def gravatar_email
    (value = read_attribute :gravatar_email).blank? ? email : value
  end

  def urls
    Hash[Social.networks.map { |key, network| [network, url(key)] }.select { |data| !data.second.blank? }]
  end

  def url(key)
    (value = read_attribute key).blank? ? nil : { original: value, shown: value.gsub(/\Ahttps?\:\/\//, '') }
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
