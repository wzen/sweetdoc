class GeneralPagevaluePaging < ActiveRecord::Base
  belongs_to :user_pagevalue
  belongs_to :general_pagevalue
end
