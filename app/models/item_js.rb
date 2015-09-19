class ItemJs

  # アイテムjsファイルのパスを取得
  # @param [String] src_name ソースファイル名
  def self.js_path(src_name)
    return "#{Rails.application.config.assets.prefix}/item/#{src_name}"
  end

  # item_idからイベントに必要なレコードを取得
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

  # itemレコードから情報を抽出する
  # @param [Array] item_all itemレコード配列
  def self.extract_iteminfo(item_all)
    ret = []
    item_all.each do |item|
      ret <<
          {
              item_id: item.id,
              js_src: self.js_path(item.src_name),
              css_temp: item.css_temp,
          }
    end

    return ret
  end

end