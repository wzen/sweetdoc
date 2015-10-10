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

  def self.new_guest
    new do |u|
      u.name = "Guest"
      u.email    = "guest_#{Time.now.to_i}#{rand(100)}@example.com"
      u.encrypted_password = [*1..9, *'A'..'Z', *'a'..'z'].sample(10).join
      u.guest    = true
    end
  end

  def active_for_authentication?
    return true
  end

end
