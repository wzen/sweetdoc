class UserPagevalue < ActiveRecord::Base
  belongs_to :user
  has_many :instance_pagevalue_pagings
  has_many :event_pagevalue_pagings
  belongs_to :setting_pagevalue
  belongs_to :gallery
end
