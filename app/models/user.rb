class User < ActiveRecord::Base
  has_many :item
  has_many :item_state
  has_one :user_auth
end
