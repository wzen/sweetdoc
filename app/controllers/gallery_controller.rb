require 'gallery/gallery'

class GalleryController < ApplicationController
  #before_action :authenticate_user!

  def index
  end

  def grid
    # ブックマークしたコンテンツ & タグからの関連コンテンツ & 今日のアクセスTopコンテンツ
    show_head = 0
    show_limit = 50
    tag_ids = Gallery.get_bookmarked_tag(current_or_guest_user.id)
    date = Date.today
    contents = Gallery.grid_index(show_head, show_limit, date, tag_ids)
    if contents.present?
      @contents = contents.uniq{|u| u[Const::Gallery::Key::GALLERY_ACCESS_TOKEN]}
    else
      @contents = {}
    end
  end

  def detail
    if mobile_access?
      # スマートフォンは全画面で表示
      redirect_to action: 'full_window'
    else
      _take_gallery_data
    end
  end

  def full_window
    _take_gallery_data
    render layout: 'gallery_fullwindow'
  end

  def embed
    _take_gallery_data
    render layout: 'gallery_fullwindow'
  end

  def _take_gallery_data
    user_id = current_or_guest_user.id
    @access_token = params.require(Const::Gallery::Key::GALLERY_ACCESS_TOKEN)
    # ViewCountをupdate
    Gallery.add_view_statistic_count(@access_token, Date.today)
    # データを取得
    @pagevalues, @message, @title, @caption, @screen_size, @creator, @item_js_list, @gallery_view_count, @gallery_bookmark_count, @show_options, @string_link, @embed_link, @bookmarked = Gallery.firstload_contents(user_id, @access_token, request.host)
  end

  def save_state
    user_id = current_or_guest_user.id
    tags = params.fetch(Const::Gallery::Key::TAGS, '').split(',').map{|t| ApplicationController.helpers.sanitize(t)}
    title = params.require(Const::Gallery::Key::TITLE).force_encoding('utf-8')
    project_id = params.require(Const::Gallery::Key::PROJECT_ID).to_i
    caption = params.fetch(Const::Gallery::Key::CAPTION, '').force_encoding('utf-8')
    thumbnail_img = params.fetch(Const::Gallery::Key::THUMBNAIL_IMG, nil)
    thumbnail_img_contents_type = params.fetch(Const::Gallery::Key::THUMBNAIL_IMG_CONTENTSTYPE, nil)
    thumbnail_img_width = params.fetch(Const::Gallery::Key::THUMBNAIL_IMG_WIDTH, nil)
    thumbnail_img_height = params.fetch(Const::Gallery::Key::THUMBNAIL_IMG_HEIGHT, nil)
    page_max = params.require(Const::Gallery::Key::PAGE_MAX)
    show_guide = params.fetch(Const::Gallery::Key::SHOW_GUIDE, false)
    show_page_num = params.fetch(Const::Gallery::Key::SHOW_PAGE_NUM, false)
    show_chapter_num = params.fetch(Const::Gallery::Key::SHOW_CHAPTER_NUM, false)
    screen_size = params.fetch(Const::Gallery::Key::SCREEN_SIZE, nil)
    if screen_size.present?
      screen_size = JSON.parse(screen_size)
    end
    upload_overwrite_gallery_token = params.fetch(Const::Gallery::Key::UPLOAD_OVERWRITE_GALLERY_TOKEN, '')
    @result_success, @message, @access_token = Gallery.save_state(
        user_id,
        project_id,
        tags,
        ApplicationController.helpers.sanitize(title),
        ApplicationController.helpers.sanitize(caption),
        thumbnail_img,
        thumbnail_img_contents_type,
        thumbnail_img_width,
        thumbnail_img_height,
        page_max,
        show_guide,
        show_page_num,
        show_chapter_num,
        screen_size,
        upload_overwrite_gallery_token
    )
  end

  def update_last_state
    user_id = current_or_guest_user.id
    tags = params.require(Const::Gallery::Key::TAGS)
    i_page_values = params.require(Const::Gallery::Key::INSTANCE_PAGE_VALUE)
    e_page_values = params.require(Const::Gallery::Key::EVENT_PAGE_VALUE)
    @result_success, @message = Gallery.update_last_state(user_id, tags, i_page_values, e_page_values)
  end

  def get_contents(show_head, show_limit, tag_id)
    show_head = params.require(Const::Gallery::SearchKey::SHOW_HEAD).to_i
    show_limit = params.require(Const::Gallery::SearchKey::SHOW_LIMIT).to_i
    search_type = params.require(Const::Gallery::SearchKey::SEARCH_TYPE)
    tag_id = params.require(Const::Gallery::SearchKey::TAG_ID).to_i
    date = params.require(Const::Gallery::SearchKey::DATE)
    contents = Gallery.get_list_contents(search_type, show_head, show_limit, tag_id, date)
    @result_success, @contents = true, contents.uniq{|u| u[Const::Gallery::Key::GALLERY_ACCESS_TOKEN]}
  end

  def get_popular_and_recommend_tags
    recommend_source_word = params.require(Const::Gallery::Key::RECOMMEND_SOURCE_WORD)
    @popular_tags = GalleryTag.get_popular_tags
    @recommend_tags = GalleryTag.get_recommend_tags(@popular_tags, recommend_source_word)
  end

  def add_bookmark
    user_id = current_or_guest_user.id
    gallery_access_token = params.require(Const::Gallery::Key::GALLERY_ACCESS_TOKEN)
    note = params.fetch(Const::Gallery::Key::NOTE, '')
    @result_success, @message = Gallery.add_bookmark(user_id, gallery_access_token, note, Date.today)
  end

  def remove_bookmark
    user_id = current_or_guest_user.id
    gallery_access_token = params.require(Const::Gallery::Key::GALLERY_ACCESS_TOKEN)
    @result_success, @message = Gallery.remove_bookmark(user_id, gallery_access_token, Date.today)
  end

  def thumbnail
    begin
      g = Gallery.find_by(access_token: params[:access_token], del_flg: false)
      if g.blank? || g.thumbnail_img.blank?
        send_file(Rails.root.join("public", 'images/gallery/image_notfound.png'), type: 'image/png', disposition: :inline)
      else
        send_data(g.thumbnail_img, type: g.thumbnail_img_contents_type, disposition: :inline)
      end
    rescue => e
      p e
    end
  end

  private :_take_gallery_data

end
