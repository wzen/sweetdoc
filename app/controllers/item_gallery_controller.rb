class ItemGalleryController < ApplicationController
  before_action :redirect_if_not_login

  include ItemGalleryConcern::Get
  include ItemGalleryConcern::Save

  def index
    @popular_tags = item_gallery_popular_tags(Const::ItemGallery::POPULAR_TAG_MENU_SHOW_MAX)
    user_id = current_or_guest_user.id
    @contents = item_gallery_index_page_data(user_id)
    @using_items = using_item_galleries(user_id)
  end

  def preview
    @item_gallery_access_token = params.require(Const::ItemGallery::Key::ITEM_GALLERY_ACCESS_TOKEN)
    @item_source_path, @item_class_name = code_filepath(@item_gallery_access_token)
  end

  def add_user_used
    user_id = current_or_guest_user.id
    item_gallery_access_token = params.require(Const::ItemGallery::Key::ITEM_GALLERY_ACCESS_TOKEN)
    result_success, message = upload_user_used_item(user_id, item_gallery_access_token, true)
    # TODO: メッセージ
    # 呼び出し元と同じ画面を表示
    p = Rails.application.routes.recognize_path(request.referrer)
    redirect_to controller: p[:controller], action: p[:action]
  end

  def add_user_used_ajax
    # FIXME: 現在未使用
    user_id = current_or_guest_user.id
    item_gallery_access_token = params.require(Const::ItemGallery::Key::ITEM_GALLERY_ACCESS_TOKEN)
    @result_success, @message = upload_user_used_item(user_id, item_gallery_access_token, true)
  end

  def remove_user_used
    user_id = current_or_guest_user.id
    item_gallery_access_token = params.require(Const::ItemGallery::Key::ITEM_GALLERY_ACCESS_TOKEN)
    result_success, message = upload_user_used_item(user_id, item_gallery_access_token, false)
    # TODO: メッセージ
    # 呼び出し元と同じ画面を表示
    p = Rails.application.routes.recognize_path(request.referrer)
    redirect_to controller: p[:controller], action: p[:action]
  end

  def edit
    # TODO:
  end

  def delete
    user_id = current_or_guest_user.id
    item_gallery_access_token = params.require(Const::ItemGallery::Key::ITEM_GALLERY_ACCESS_TOKEN)
    result_success, message = delete_item(user_id, item_gallery_access_token)
    # TODO: メッセージ
    # マイページ:CreatedItemsを表示
    redirect_to '/my_page/created_items'
  end

  def save_state
    user_id = current_or_guest_user.id
    tags = params.fetch(Const::ItemGallery::Key::TAGS, '').split(',').map{|t| ApplicationController.helpers.sanitize(t)}
    title = params.require(Const::ItemGallery::Key::TITLE).force_encoding('utf-8')
    user_coding_id = params.require(Const::ItemGallery::Key::USER_CODING_ID).to_i
    caption = params.fetch(Const::Gallery::Key::CAPTION, '').force_encoding('utf-8')
    @result_success, @message, @access_token = save_item_gallery_state(
        user_id,
        user_coding_id,
        tags,
        ApplicationController.helpers.sanitize(title),
        ApplicationController.helpers.sanitize(caption)
    )
  end

end
