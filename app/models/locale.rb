class Locale < ActiveRecord::Base
  has_many :localize_item_action_event
  has_many :localize_item
end
