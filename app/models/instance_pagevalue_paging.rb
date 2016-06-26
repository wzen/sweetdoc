class InstancePagevaluePaging < ActiveRecord::Base
  belongs_to :user_pagevalue
  belongs_to :instance_pagevalue
end
