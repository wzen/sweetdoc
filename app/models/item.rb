class Item < ActiveRecord::Base
  has_many :item_categories
  has_many :item_action_events
  has_many :item_css_temps
  belongs_to :user, :foreign_key => :create_user_id
end
