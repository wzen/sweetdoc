class CommonAction < ActiveRecord::Base
  def self.get_all
    ret = Rails.cache.fetch('common_actions_all') do
      self.all.select('title, dist_token')
    end
    return ret
  end
end
