class ItemJs

  # アイテムjsファイルのパスを取得
  # @param [String] src_name ソースファイル名
  def self.js_path(src_name)
    return "#{Rails.application.config.assets.prefix}/item_state/#{src_name}"
  end

  # item_action_eventレコードからタイムラインイベント用のアクション情報を取り出す
  # @param [Array] item_action_events item_action_eventレコード配列
  def self.timeline_event_actions(item_action_events)
    return item_action_events.map do |d|
      {
          item_id: d.item_id,
          action_event_type_id: d.action_event_type_id,
          method_name: d.method_name,
          options: d.options
      }
    end
  end

  # item_action_eventのレコードからタイムラインイベント用のアクション値情報を取り出す
  # @param [Array] item_action_events item_action_eventレコード配列
  def self.timeline_event_values(item_action_events)
    values = ''
    item_action_events.each do |d|
      values += ItemJsController.new.timeline_config(d)
    end
    return values
  end

  # item_idからタイムラインイベントに必要なレコードを取得
  # @param [Int] item_id アイテムID
  def self.find_events_by_itemid(item_id)
    item_action_events = ItemActionEvent.joins(:item).where(item_id: item_id)
                             .joins(:locales).merge(Locale.available)
                             .select('item_action_events.*, localize_item_action_events.options as l_options, items.src_name as item_src_name, items.css_temp as item_css_temp')

    # optionsをJsonString→HashArrayに変更
    item_action_events.each do |c|
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

    return item_action_events
  end

  # item_idの配列からタイムラインイベントに必要なレコードを取得
  # @param [Array] item_ids アイテムIDの配列
  def self.find_events_by_itemids(item_ids)
    item_action_events_all = ItemActionEvent.joins(:item).where(item_id: item_ids)
                             .joins(:locales).merge(Locale.available)
                             .select('item_action_events.*, localize_item_action_events.options as l_options, items.src_name as item_src_name, items.css_temp as item_css_temp')

    ret = []
    item_ids.each do |item_id|
      item_action_events = item_action_events_all.find_by(item_id: item_id)
      next if item_action_events.length == 0

      # optionsをJsonString→HashArrayに変更
      item_action_events.each do |c|
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
    end

    return item_action_events_all
  end

  # item_action_eventから情報を抽出する
  # @param [Array] item_action_events item_action_eventレコード配列
  def self.extract_iae(item_action_events)
    # JSファイル取得
    js_src = self.js_path(item_action_events.first.item_src_name)

    if item_action_events.first.item_css_temp
      # CSS取得
      css_info = item_action_events.first.item_css_temp
    end

    # TODO: デザインconfig取得

    # タイムライン アクション名一覧
    te_actions = self.timeline_event_actions(item_action_events)
    # タイムライン コンフィグUI
    te_values = self.timeline_event_values(item_action_events)

    ret =
    {
        item_id: item_action_events.first.item_id,
        js_src: js_src,
        css_info: css_info,
        te_actions: te_actions,
        te_values: te_values
    }
    return ret
  end

  def self.get_user_iae_infos(user_id, loaded_itemids)
    result = ItemState.where(:user_id => user_id).order(id: :desc).first
    item_js_list = []
    if result == nil
      message = I18n.t('message.database.item_state.load.error')
      return nil
    else
      message = I18n.t('message.database.item_state.load.success')
      item_states = JSON.parse(result.state)
      itemids = []
      item_states.each do |item_state|
        item_type = item_state['obj']['itemType']
        unless loaded_itemids.include?(item_type)
          itemids << item_type
        end
      end

      item_action_events_all = ItemJs.find_events_by_itemids(itemids)
      ret = []
      item_action_events_all.each do |item_action_events|
        ret << ItemJs.extract_iae(item_action_events)
      end

      return ret
    end
  end

end