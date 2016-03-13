module Shared
class User < ActiveRecord::Base
  include Followable
  include Users::Searchable

  devise :database_authenticatable,
         :confirmable,
         :lockable,
         :recoverable,
         :registerable,
         :rememberable,
         :trackable,
         :validatable,

         authentication_keys: [:login]

  if Rails.module.mooc?
    # TODO (ladislav.gallay) Move to mooc user model
    ROLES = [:student, :teacher, :teacher_assistant, :administrator]
  else
    ROLES = [:student, :teacher, :administrator]
  end

  has_many :documents,   class_name: :'University::Document', foreign_key: :author_id, dependent: :destroy
  has_many :questions,   foreign_key: :author_id, dependent: :destroy
  has_many :answers,     foreign_key: :author_id, dependent: :destroy
  has_many :comments,    foreign_key: :author_id, dependent: :destroy
  has_many :evaluations, foreign_key: :author_id, dependent: :destroy

  has_many :labelings, foreign_key: :author_id, dependent: :destroy
  has_many :labels, through: :labelings

  has_many :activities,    foreign_key: :initiator_id, dependent: :destroy
  has_many :favorites,     foreign_key: :favorer_id,   dependent: :destroy
  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy
  has_many :views,         foreign_key: :viewer_id,    dependent: :destroy
  has_many :votes,         foreign_key: :voter_id,     dependent: :destroy
  has_many :watchings,     foreign_key: :watcher_id,   dependent: :destroy

  has_many :assignments, dependent: :destroy
  has_many :roles,      through: :assignments
  has_many :categories, through: :assignments

  has_many :profiles, class_name: :'Shared::User::Profile', dependent: :destroy
  has_many :context_users

  validates :role, presence: true

  # TODO (smolnar) consult usage of functional indices for nick, login and email uniqueness checking
  validates :login, format: { with: /\A[A-Za-z0-9_]+\z/ }, presence: true, uniqueness: { case_sensitive: false }
  validates :nick,  format: { with: /\A[A-Za-z0-9_]+\z/ }, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 40 }, if: :login?

  validates :gravatar_email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ }, allow_blank: true

  validates :first, format: { with: /\A\p{Lu}[\p{Ll}\-\p{Lu}]*\z/u }, allow_blank: true
  validates :last,  format: { with: /\A\p{Lu}[\p{Ll}\-\p{Lu}]*\z/u }, allow_blank: true

  scope :by, lambda { |args| where(args).first || raise(ActiveRecord::RecordNotFound) }
  scope :recent, lambda { where('users.created_at >= ?', Time.now - 1.month ) }
  scope :alumni, lambda { where(alumni: true) }
  scope :in_context, lambda { |context| includes(:context_users).where(context_users: { context: context }).where.not(context_users: { id: nil }) unless Rails.module.university? }

  Shared::Social.networks.each do |key, network|
    validates key, format: { with: network.regexp }, allow_blank: true
  end

  symbolize :role, in: ROLES

  before_validation :resolve_nick, on: :create

  after_create :create_reputation_profile

  self.table_name = 'users'

  def activities_seen_by(user)
    user == self ? activities.unscope(where: :anonymous) : activities
  end

  def login=(value)
    write_attribute :login, value.to_s.downcase

    self.nick ||= login
  end

  def name
    (value = "#{first} #{middle} #{last}".squeeze(' ').strip).blank? ? nil : value
  end

  def can_destroy?
    false
  end

  def gravatar_email
    (value = read_attribute :gravatar_email).blank? ? email : value
  end

  def assigned?(category, role)
    assignments.where(category: category).joins(:role).where(roles: { name: role }).any? || (assignments.where(category: category).none? && self.role == role.to_sym)
  end

  def assigned_categories(role = nil)
    return assignments.map { |t| t.category } if role.nil?

    role = Shared::Role.find_by(name: role.to_s) if role.is_a? Symbol
    role = role.id if role.is_a? ActiveRecord::Base
    list = association(:assignments).loaded? ? assignments.select { |item| item.role_id = role } : assignments.includes(:category).where({ role_id: role })

    list.map { |t| t.category }
  end

  def role?(role)
    self.role == role.to_sym
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

  def from_omniauth(auth, friends = nil, likes = nil)
    self.omniauth_provider         = auth.provider
    self.omniauth_token            = auth.credentials.token
    self.omniauth_token_expires_at = Time.at(auth.credentials.expires_at)

    self.facebook         = auth.extra.raw_info.link.to_s.gsub(/www./, '')
    self.facebook_uid     = auth.uid
    self.facebook_friends = friends.to_s
    self.facebook_likes   = likes.to_s

    self.save!
  end

  def related_contexts
    context_users.empty? ? Shared::Category.where(depth: 1) : Shared::Category.where(uuid: context_users.pluck(:context))
  end

  protected

  def password_required?
    ais_login ? false : super
  end

  def resolve_nick
    nick, k = self.nick, 1

    self.nick = "#{nick}#{k += 1}" while User.where(nick: self.nick).where.not(id: self.id).exists?
  end

  def create_reputation_profile
    User::Profile.create(user: self, targetable_id: 1, targetable_type: 'Reputation', property: 'Reputation', value: 0, probability: 0.0)
  end
end
end
