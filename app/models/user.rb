class User < ActiveRecord::Base
  has_many :items
  has_many :user_pagevalues
  has_one :user_auth
  has_many :galleries
end
