class ItemJsController < ApplicationController

  def index
    item_id = params['itemId']

    # JSファイル取得
    @js_src = ItemJs.get_lack_js(item_id)

    data = ItemJs.item_contents(item_id)

    # CSS取得
    if data.first.item_css_temp != nil
      @css_info = data.first.item_css_temp
    end
    # デザインconfig取得

    # タイムラインconfig取得
    @te_actions = nil
    @te_values = nil

  end

end
