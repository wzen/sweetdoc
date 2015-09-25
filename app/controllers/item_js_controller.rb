require 'item/item'
require 'item/item_js'

class ItemJsController < ApplicationController

  def index
    item_ids = params['itemIds']
    @indexes = ItemJs.extract_iteminfo(Item.find(item_ids))
  end

end
