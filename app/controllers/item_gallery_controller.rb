require 'item_gallery/item_gallery'

class ItemGalleryController < ApplicationController
  def index
    user_id = current_or_guest_user.id

    # Constantの設定
    init_const

    # ItemGallery & UserItemGallery


  end

  def preview
    # Constantの設定
    init_const
    @item_gallery_access_token = params.require(Const::ItemGallery::Key::ITEM_GALLERY_ACCESS_TOKEN)
    @item_source_path = ItemGallery.code_filepath(@item_gallery_access_token)
  end

  def add_user_used
    user_id = current_or_guest_user.id
    item_gallery_access_token = params.require(Const::ItemGallery::Key::ITEM_GALLERY_ACCESS_TOKEN)
    result_success, message = ItemGallery.upload_user_used(user_id, item_gallery_access_token, true)
  end

  def add_user_used_ajax
    user_id = current_or_guest_user.id
    item_gallery_access_token = params.require(Const::ItemGallery::Key::ITEM_GALLERY_ACCESS_TOKEN)
    @result_success, @message = ItemGallery.upload_user_used(user_id, item_gallery_access_token, true)
  end
  def remove_user_used_ajax
    user_id = current_or_guest_user.id
    item_gallery_access_token = params.require(Const::ItemGallery::Key::ITEM_GALLERY_ACCESS_TOKEN)
    @result_success, @message = ItemGallery.upload_user_used(user_id, item_gallery_access_token, false)
  end

  def save_state
    user_id = current_or_guest_user.id
    tags = params.fetch(Const::ItemGallery::Key::TAGS, '').split(',').map{|t| ApplicationController.helpers.sanitize(t)}
    title = params.require(Const::ItemGallery::Key::TITLE).force_encoding('utf-8')
    user_coding_id = params.require(Const::ItemGallery::Key::USER_CODING_ID).to_i
    caption = params.fetch(Const::Gallery::Key::CAPTION, '').force_encoding('utf-8')
    @result_success, @message, @access_token = ItemGallery.save_state(
        user_id,
        user_coding_id,
        tags,
        ApplicationController.helpers.sanitize(title),
        ApplicationController.helpers.sanitize(caption)
    )
  end
end
