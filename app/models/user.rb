class User < ActiveRecord::Base
  has_many :items
  has_many :user_pagevalues
  has_one :user_auth
  has_many :galleries
  has_many :gallery_bookmarks

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, omniauth_providers: [:twitter, :facebook]
end
