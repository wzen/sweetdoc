require 'item/preload_item'
require 'item/item_js'

class ItemJsController < ApplicationController

  def index
    item_ids = params['itemIds']
    @result_success = true
    @indexes = ItemJs.extract_iteminfo(PreloadItem.find(item_ids))
  end

end
