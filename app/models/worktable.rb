class Worktable
  def self.init_common_events
    # 共通タイムラインイベントの取得
    common_actions = CommonAction.joins(:common_action_events).eager_load(:common_action_events)
                         .joins(:localize_common_action_events).eager_load(:localize_common_action_events)
                         .joins(:locales).merge(Locale.available)

    # optionsをJsonString→HashArrayに変更
    common_actions.each do |c|
      c.common_action_events.each do |a|
        # if c.options
        #   c.options = JSON.parse(c.options)
        # else
        #   c.options = {}
        # end
        if a.localize_common_action_events.first.options
          # optionsのローカライズをマージ
          a.options = JSON.parse(a.localize_common_action_events.first.options)
        end
      end
    end

    return common_actions
  end
end