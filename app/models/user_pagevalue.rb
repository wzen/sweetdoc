class UserPagevalue < ActiveRecord::Base
  belongs_to :user
  has_one :instance_pagevalue_paging
  has_many :instance_pagevalues, through: :instance_pagevalue_paging
  has_one :event_pagevalue_paging
  has_many :event_pagevalues, through: :event_pagevalue_paging
  belongs_to :setting_pagevalue
end
