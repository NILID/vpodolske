class User < ActiveRecord::Base
  acts_as_voter
  acts_as_liker

  before_create :init_role
  after_create :init_new

  has_many :videos
  has_one :profile
  has_many :events
  has_many :notes
  has_many :organizations
  has_many :places
  has_many :photos

  extend FriendlyId
  friendly_id :login, use: %i[slugged history]

  accepts_nested_attributes_for :profile

  LOGIN_BLACKLIST = %w[admin administrator hostmaster info postmaster root ssladmin ssladministrator sslwebmaster sysadmin webmaster support contact help xpodolsk podolsk]
  ROLES = %w[admin user moderator guest]
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: %i[vkontakte]

  validates :login,
      presence: true,
      uniqueness: true,
      exclusion: { in: LOGIN_BLACKLIST },
      length: { in: 3..12 },
      format: { with: /\A[A-Za-z0-9_]+\z/ }

  # online users scope
  scope :online, -> { where('updated_at > ?', 10.minutes.ago) }
  scope :admins, -> { with_role(:admin) }

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end

  def self.with_role(role)
    where('roles_mask & ? > 0', 2**ROLES.index(role.to_s))
  end

  def role?(role)
    roles.include? role.to_s
  end

  def is?(role)
    roles.include?(role.to_s)
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid      = auth.uid
      user.login    = user.set_login(auth, auth.extra.raw_info.screen_name)
      # user.email  = auth.uid.to_s + '@vkontakte.com'
      user.email    = auth.info.email ? auth.info.email : (auth.uid.to_s + '@vkontakte.com')
      user.confirmed_at  = DateTime.now
      user.auth_raw_info = auth.credentials.token
      user.save
    end
  end

  def set_login(auth, screen_name)
    auth_uid = auth.uid.to_s
    auth_first_name = auth.first_name.to_s
    # users = screen_name.present? ? User.where(login: screen_name).pluck(:id).count : 0

    # if screen_name.present? && users == 0
    #   screen_name
    if screen_name.present?
      screen_name + "_#{auth_uid}"
    else
      auth_first_name + '_' + auth_uid
    end
  end

  def token
    return '' if auth_raw_info.is_a?(String)
    auth_raw_info.try(:credentials).try(:token)
  end

  def self.new_with_session(params, session)
    if session['devise.user_attributes']
      new(session['devise.user_attributes'], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def password_required?
    super && provider.blank?
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

  # return online users
  def online?
    updated_at > 10.minutes.ago
  end

  private

  def init_role
    self.roles_mask = 2
  end

  def init_new
    self.build_profile
  end
end
