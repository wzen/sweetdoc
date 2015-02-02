class ItemJsController < ApplicationController

  def index
    item_id = params['itemId']
    data = ItemJs.item_contents(item_id)

    if data.first.item_src_name
      # JSファイル取得
      @js_src = ItemJs.get_lack_js(data.first.item_src_name)
    end

    if data.first.item_css_temp != nil
      # CSS取得
      @css_info = data.first.item_css_temp
    end

    # デザインconfig取得

    # タイムライン アクション名一覧
    @te_actions = data.map do |d|
      {
          item_id: d.item_id,
          action_event_type_id: d.action_event_type_id,
          method_name: d.method_name,
          options: d.options
      }
    end
    # タイムライン コンフィグUI
    @te_values = ''
    data.each do |d|
      @te_values += timeline_config(d)
    end

  end


  def timeline_config(te_action)
    @class_name = Const::ElementAttribute::TE_VALUES_CLASS
                      .sub(/@itemid/, te_action[:item_id].to_s)
                      .sub(/@methodname/, te_action[:method_name])
    @type = te_action.options['type']
    render_to_string :layout => false
  end

end
