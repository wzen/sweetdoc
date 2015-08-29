class UserPagevalue < ActiveRecord::Base
  belongs_to :user
  belongs_to :instance_pagevalue_paging
  belongs_to :event_pagevalue_paging
  belongs_to :setting_pagevalue
end
