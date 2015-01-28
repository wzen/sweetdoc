require 'const'

class WorktableController < ApplicationController
  def index
    # Constantの設定
    init_const

    # 共通タイムラインイベントの設定
    common_action_events = CommonActionEvent
                        .joins(:locales).merge(Locale.available)
                        .select('common_action_events.*, localize_common_action_events.options as l_options')
    # アイテム選択
    @select_items = select_items(common_action_events)

    # メソッド選択
    @action_event_type_ids = []
    common_action_events.each do |c|
      @action_event_type_ids << {id: c.id , action_event_type_id: c.action_event_type_id}
    end
  end

  private
  def merge_options(common_action_events)
    options_array = []
    common_action_events.each do |c|
      options = {}
      if c.options
        options.merge!(JSON.parse(c.options))
      end
      if c.l_options
        options.merge!(JSON.parse(c.l_options))
      end
      options_array << {id:c.id, options: options}
    end
    return options_array
  end

  private
  def select_items(common_action_events)
    select = []
    select << {name: '(Select)', value: ''}
    merged = merge_options(common_action_events)
    merged.each do |m|
      select << {name: m[:options]['name'], value: "c#{m[:id]}"}
    end
    return select
  end
end
