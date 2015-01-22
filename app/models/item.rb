class Item < ActiveRecord::Base
  has_many :item_category
  has_many :item_action_event
  has_many :item_css_temp
  belongs_to :user, :foreign_key => :create_user_id
end
