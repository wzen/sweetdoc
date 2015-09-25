class LocalizeCommonActionEvent < ActiveRecord::Base
  belongs_to :locale
  belongs_to :common_action_event
end
