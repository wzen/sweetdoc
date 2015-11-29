class ItemGalleryController < ApplicationController
  def index
  end

  def preview
    # Constantの設定
    init_const
  end

  def upload_user_used

  end

  def save_state
    user_id = current_or_guest_user.id
    tags = params.require(Const::Gallery::Key::TAGS).split(',').map{|t| ApplicationController.helpers.sanitize(t)}
    title = params.require(Const::Gallery::Key::TITLE).force_encoding('utf-8')
    user_coding_id = params.require(Const::Gallery::Key::USER_CODING_ID)
    if project_id == nil || title == nil || title.length == 0
      # エラー
      @message, @access_token = I18n.t('message.database.item_state.save.error')
    else
      project_id = project_id.to_i
      caption = params[Const::Gallery::Key::CAPTION].force_encoding('utf-8')
      thumbnail_img = params[Const::Gallery::Key::THUMBNAIL_IMG]
      thumbnail_img_contents_type = params[Const::Gallery::Key::THUMBNAIL_IMG_CONTENTSTYPE]
      page_max = params[Const::Gallery::Key::PAGE_MAX]
      show_guide = params[Const::Gallery::Key::SHOW_GUIDE]
      show_page_num = params[Const::Gallery::Key::SHOW_PAGE_NUM]
      show_chapter_num = params[Const::Gallery::Key::SHOW_CHAPTER_NUM]
      @result_success, @message, @access_token = Gallery.save_state(
          user_id,
          project_id,
          tags,
          ApplicationController.helpers.sanitize(title),
          ApplicationController.helpers.sanitize(caption),
          thumbnail_img,
          thumbnail_img_contents_type,
          page_max,
          show_guide,
          show_page_num,
          show_chapter_num)
    end
  end

end
