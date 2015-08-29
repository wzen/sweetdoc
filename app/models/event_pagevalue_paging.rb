class EventPagevaluePaging < ActiveRecord::Base
  has_many :user_pagevalues
  belongs_to :event_pagevalue
end
