class ItemJsController < ApplicationController

  def index
    item_type = params['itemType']
    @js_src = ItemJs.new.get_lack_js(item_type)
    # data = {
    #     :js_src => ItemJs.new.get_lack_js(item_type)
    # }
    css_temp = ItemCssTemp.find_by_item_type(item_type)
    if css_temp != nil
      @css_info = css_temp.contents
    end
    #render json: data
  end

end
