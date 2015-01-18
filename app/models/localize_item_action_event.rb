class LocalizeItemActionEvent < ActiveRecord::Base
  belongs_to :locale
  belongs_to :item_action_event
end
