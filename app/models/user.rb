class User < ActiveRecord::Base
  has_many :items
  has_many :item_states
  has_one :user_auth
end
