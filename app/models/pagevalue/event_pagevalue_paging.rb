class EventPagevaluePaging < ActiveRecord::Base
  belongs_to :user_pagevalue
  belongs_to :event_pagevalue
end
