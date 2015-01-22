class ItemJsController < ApplicationController

  def index
    item_type = params['itemType']

    # JSファイル取得
    @js_src = ItemJs.new.get_lack_js(item_type)
    # CSS取得
    css_temp = ItemCssTemp.find_by_item_id(item_type)
    if css_temp != nil
      @css_info = css_temp.contents
    end
    # デザインconfig取得

    # イベントconfig取得
    #event_confing = Ite
  end

end
