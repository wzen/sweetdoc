require 'item/item_image'

class ItemImageController < ApplicationController
  def create
    user_id = current_or_guest_user.id
    project_id = params.require(Const::PreloadItemImage::Key::PROJECT_ID)
    item_obj_id = params.require(Const::PreloadItemImage::Key::ITEM_OBJ_ID)
    event_dist_id = params.fetch(Const::PreloadItemImage::Key::EVENT_DIST_ID, nil)
    file_path = params[:file_path]
    url = params.fetch(Const::PreloadItemImage::Key::PROJECT_ID, nil)
    @result_success, @message, @image_url = ItemImage.create_img(user_id, project_id, item_obj_id, event_dist_id, file_path, url)
  end
end
