class ItemActionEvent < ActiveRecord::Base
  has_many :localize_item_action_events
end
