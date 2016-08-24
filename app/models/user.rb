class User < ActiveRecord::Base
  has_many :user_pagevalues
  has_one :user_auth
  has_many :galleries
  has_many :gallery_bookmarks

  validates_confirmation_of :password

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, omniauth_providers: [:twitter, :facebook, :google_oauth2, :line]

  mount_uploader :thumbnail_img, UserThumbnailImageUploader

  def active_for_authentication?
    return true
  end
end
