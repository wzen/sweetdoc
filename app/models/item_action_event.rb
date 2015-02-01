class ItemActionEvent < ActiveRecord::Base
  has_many :localize_item_action_events
  has_many :locales, :through => :localize_item_action_events
  belongs_to :item
end
