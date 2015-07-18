class CommonAction < ActiveRecord::Base
  has_many :common_action_events
  has_many :localize_common_action_events, through: :common_action_events
  has_many :locales, through: :localize_common_action_events
end
