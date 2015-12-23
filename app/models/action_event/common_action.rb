class CommonAction < ActiveRecord::Base
  has_many :common_action_events
  has_many :localize_common_action_events, through: :common_action_events
  has_many :locales, through: :localize_common_action_events

  def self.get_all
    ret = Rails.cache.fetch('common_actions_all') do
      self.all.select('title, dist_token')
    end
    return ret
  end
end
