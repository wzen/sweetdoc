class Locale < ActiveRecord::Base
  has_many :localize_common_action_events
  has_many :localize_items

  scope :available, -> do
    where(i18n_locale: I18n.locale)
  end
end
