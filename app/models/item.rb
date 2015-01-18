class Item < ActiveRecord::Base
  has_many :item_action_event
  belongs_to :user, :foreign_key => :create_user_id
end
