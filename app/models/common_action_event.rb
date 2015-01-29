class CommonActionEvent < ActiveRecord::Base
  has_many :localize_common_action_events
  has_many :locales, :through => :localize_common_action_events

  def self.get_commonevents_initworktable
    # 共通タイムラインイベントの取得
    common_action_events = self.joins(:locales).merge(Locale.available)
                               .select('common_action_events.*, localize_common_action_events.options as l_options')

    # optionsをJsonString→HashArrayに変更
    common_action_events.each do |c|
      c.options = JSON.parse(c.options)
      if c.l_options
        # optionsのローカライズをマージ
        c.options.merge!(JSON.parse(c.l_options))
      end
    end

    return common_action_events
  end

end
