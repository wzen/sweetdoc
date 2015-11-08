require 'action_event/common_action'
require 'action_event/common_action_event'
require 'action_event/localize_common_action_event'
require 'common/locale'

class Worktable
  def self.init_common_events
    # 共通イベントの取得
    common_actions = CommonAction.joins(:common_action_events).eager_load(:common_action_events)
                         .joins(:localize_common_action_events).eager_load(:localize_common_action_events)
                         .joins(:locales).merge(Locale.available)

    # optionsをJsonString→HashArrayに変更
    common_actions.each do |c|
      c.common_action_events.each do |a|
        if a.localize_common_action_events.first.options
          # optionsのローカライズをマージ
          a.options = JSON.parse(a.localize_common_action_events.first.options)
        end
      end
    end

    return common_actions
  end

  def self.get_design_config(design_config)
    ret = ApplicationController.new.render_to_string(
        partial: 'worktable/sidebar_menu/design/parts/common'
    )
    if design_config.is_a?(String)
      if design_config == Const::ItemDesignOptionType::DESIGN_TOOL
        ret += ApplicationController.new.render_to_string(
            partial: 'worktable/sidebar_menu/design/parts/design_tool'
        )
      end
    elsif design_config.is_a?(Object)
      design_config.each do |var, v|
        temp = ''
        if v['type'] == Const::ItemDesignOptionType::NUMBER
          temp = 'worktable/sidebar_menu/design/parts/slider'
        elsif v['type'] == Const::ItemDesignOptionType::STRING
          temp = 'worktable/sidebar_menu/design/parts/textbox'
        elsif v['type'] == Const::ItemDesignOptionType::COLOR
          temp = 'worktable/sidebar_menu/design/parts/color'
        end
        ret += ApplicationController.new.render_to_string(
            partial: temp,
            locals: {
                var_name: var,
                options: v['options']
            }
        )
      end
    end
    return ret
  end
end