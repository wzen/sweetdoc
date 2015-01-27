class ItemJsController < ApplicationController

  def index
    item_id = params['itemId']

    # JSファイル取得
    @js_src = ItemJs.new.get_lack_js(item_id)
    # CSS取得
    css_temp = ItemCssTemp.find_by_item_id(item_id)
    if css_temp != nil
      @css_info = css_temp.contents
    end
    # デザインconfig取得

    # イベントconfig取得
    #event_config = Item.find(item_id, :joins => 'item_action_events')

  end

end
