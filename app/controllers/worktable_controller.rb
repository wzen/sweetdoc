class WorktableController < ApplicationController
  def index
    # Constantの設定
    init_const

    # 共通タイムラインイベントの設定
    common_events = CommonActionEvent
                        .includes(:localize_common_action_events)
                        .joins(:locales).merge(Locale.available)

    @select_forms = []
    @select_forms << {name: '(Select)', value: ''}
    common_events.each do |c|
      name = nil
      unless !c.localize_common_action_events.empty?
        l_events = c.localize_common_action_events
        l_events.each do |l|
          if l.options
            o = JSON.parse(c.localize_common_action_events.options)
            if o.name
              name = o.name
            end
          end
        end
      end
      if name == nil && c.options
        o = JSON.parse(c.options)
        if o.name
          name = o.name
        end
      end
      name ||= ''
      @select_forms << {name: name, value: "c#{c.id}"}
    end
  end
end
