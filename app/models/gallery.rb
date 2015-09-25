class Gallery < ActiveRecord::Base
  belongs_to :user
  belongs_to :gallery_tag
  has_many :gallery_instance_pagevalue_pagings
  has_many :gallery_event_pagevalue_pagings
end
