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

    # タイムラインconfig取得
    @te_actions = nil
    @te_values = nil

  end

end
