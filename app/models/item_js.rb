class ItemJs

  def self.js_path(src_name)
    return "#{Rails.application.config.assets.prefix}/item/#{src_name}"
  end

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

  def self.timeline_event_values(item_action_events)
    values = ''
    item_action_events.each do |d|
      values += ItemJsController.new.timeline_config(d)
    end
    return values
  end

  def self.item_contents(item_id)
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

  def self.item_contents_by_itemids(item_ids)
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

  def self.suitable_data(item_action_events)
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

    return
    {
        item_id: item_action_events.first.item_id,
        js_src: js_src,
        css_info: css_info,
        te_actions: te_actions,
        te_values: te_values
    }
  end

  def self.get_item_info_list(user_id, loaded_item_type_list)
    result = ItemState.where(:user_id => user_id).order(id: :desc).first
    item_js_list = []
    if result == nil
      message = I18n.t('message.database.item_state.load.error')
      return nil
    else
      message = I18n.t('message.database.item_state.load.success')
      item_list = JSON.parse(result.state)
      item_type_list = []
      item_list.each do |item|
        item_type = item['obj']['itemType']
        unless loaded_item_type_list.include?(item_type)
          item_type_list << item_type
        end
      end

      item_action_events_all = ItemJs.item_contents_by_itemids(item_type_list)
      ret = []
      item_action_events_all.each do |item_action_events|
        ret << ItemJs.suitable_data(item_action_events)
      end

      return ret
    end
  end

end