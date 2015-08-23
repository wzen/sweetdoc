class UserPagevalue < ActiveRecord::Base
  belongs_to :user
  belongs_to :instance_pagevalue
  belongs_to :event_pagevalue
  belongs_to :setting_pagevalue
end
