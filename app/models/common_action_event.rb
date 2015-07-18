class CommonActionEvent < ActiveRecord::Base
  has_many :localize_common_action_events
  has_many :locales, :through => :localize_common_action_events
  belongs_to :common_action
end
