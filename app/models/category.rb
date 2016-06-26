class Category < ActiveRecord::Base
  has_many :item_categories
end
