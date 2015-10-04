class UserPagevalue < ActiveRecord::Base
  belongs_to :user_project_map
  has_many :general_pagevalue_pagings
  has_many :instance_pagevalue_pagings
  has_many :event_pagevalue_pagings
  belongs_to :setting_pagevalue
end
