class PreloadItem < ActiveRecord::Base
  has_many :item_categories
  belongs_to :user, :foreign_key => :create_user_id

  def self.get_all
    ret = Rails.cache.fetch('preload_items_all') do
      self.all.select('title, dist_token')
    end
    return ret
  end
end