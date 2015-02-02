class ItemJs
  def self.get_lack_js(src_name)
    return "#{Rails.application.config.assets.prefix}/item/#{src_name}"
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

end