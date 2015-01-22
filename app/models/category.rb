class Category < ActiveRecord::Base
  has_many :item_category
end
