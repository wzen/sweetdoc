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

  def upload_user_used

    # ItemGallery IndexにRedirect
  end

  def save_state
    user_id = current_or_guest_user.id
    tags = params.require(Const::ItemGallery::Key::TAGS).split(',').map{|t| ApplicationController.helpers.sanitize(t)}
    title = params.require(Const::ItemGallery::Key::TITLE).force_encoding('utf-8')
    user_coding_id = params.require(Const::ItemGallery::Key::USER_CODING_ID)
    if user_coding_id == nil || title == nil || title.length == 0
      # エラー
      @message, @access_token = I18n.t('message.database.item_state.save.error')
    else
      user_coding_id = user_coding_id.to_i
      caption = params[Const::Gallery::Key::CAPTION].force_encoding('utf-8')
      @result_success, @message, @access_token = ItemGallery.save_state(
          user_id,
          user_coding_id,
          tags,
          ApplicationController.helpers.sanitize(title),
          ApplicationController.helpers.sanitize(caption)
      )
    end
  end

end
