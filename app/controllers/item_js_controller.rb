class ItemJsController < ApplicationController
  include ItemJsConcern::Get

  def index
    access_token = params.require(Const::ItemGallery::Key::ITEM_GALLERY_ACCESS_TOKEN)
    @result_success = true
    @indexes = get_item_gallery(access_token)
  end

end
