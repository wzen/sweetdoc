class User < ActiveRecord::Base
  has_many :items
  has_many :user_pagevalues
  has_one :user_auth
  has_many :galleries
  has_many :gallery_bookmarks

  validates_confirmation_of :password
  #has_secure_password

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, omniauth_providers: [:twitter, :facebook, :google]

  def self.generate_access_token
    return SecureRandom.urlsafe_base64(20)
  end

  def active_for_authentication?
    return true
  end

  def self.new_guest
    new do |u|
      u.name = "Guest"
      u.email    = "guest_#{Time.now.to_i}#{rand(100)}@example.com"
      u.encrypted_password = [*1..9, *'A'..'Z', *'a'..'z'].sample(10).join
      u.guest    = true
      u.access_token = generate_access_token
    end
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(
          access_token: generate_access_token,
          name:     auth.extra.raw_info.name,
          provider: auth.provider,
          uid:      auth.uid,
          email:    auth.info.email,
          password: Devise.friendly_token[0,20]
      )
    end
    user
  end

  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(
          access_token: generate_access_token,
          name:     auth.info.nickname,
          provider: auth.provider,
          uid:      auth.uid,
          email:    auth.info.email,
          #service_token:    auth.credentials.token,
          password: Devise.friendly_token[0,20] )
    end
    return user
  end

end
