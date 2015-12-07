require 'item/preload_item'
require 'item/item_js'

class ItemJsController < ApplicationController

  def index
    access_token = params.require(Const::ItemGallery::Key::ITEM_GALLERY_ACCESS_TOKEN)
    @result_success = true
    @indexes = ItemJs.get_item_gallery(access_token)
  end

end
