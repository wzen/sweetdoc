class Worktable
  def self.init_common_events
    # 共通タイムラインイベントの取得
    common_action_events = CommonActionEvent.joins(:locales).merge(Locale.available)
                               .select('common_action_events.*, localize_common_action_events.options as l_options')

    # optionsをJsonString→HashArrayに変更
    common_action_events.each do |c|
      if c.options
        c.options = JSON.parse(c.options)
      else
        c.options = {}
      end
      if c.l_options
        # optionsのローカライズをマージ
        c.options.update(JSON.parse(c.l_options))
      end
    end

    return common_action_events
  end
end