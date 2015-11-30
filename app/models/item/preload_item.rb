class PreloadItem < ActiveRecord::Base
  has_many :item_categories
  belongs_to :user, :foreign_key => :create_user_id
end