class InstancePagevaluePaging < ActiveRecord::Base
  has_many :user_pagevalues
  belongs_to :instance_pagevalue
end
