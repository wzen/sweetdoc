class WorktableController < ApplicationController
  def index
    # Constantの設定
    init_const

    # 共通タイムラインイベントの設定
    common_events = CommonActionEvent
                        .includes(:localize_common_action_events)
                        .joins(:locales).merge(Locale.available)
    # アイテム選択
    @select_items = select_items(common_events)
    # メソッド選択
    @select_methods = select_methods(common_events)
  end

  private
  def select_items(common_events)
    select = []
    select << {name: '(Select)', value: ''}
    common_events.each do |c|
      name = nil
      unless c.localize_common_action_events.empty?
        l_events = c.localize_common_action_events
        l_events.each do |l|
          if l.options
            o = JSON.parse(l.options)
            if o['name']
              name = o['name']
            end
          end
        end
      end
      if name == nil && c.options
        o = JSON.parse(c.options)
        if o['name']
          name = o['name']
        end
      end
      name ||= ''
      select << {name: name, value: "c#{c.id}"}
    end
    return select
  end

  private
  def select_methods(common_events)
    methods = []

  end
end
