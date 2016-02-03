require 'gallery/gallery'

class GalleryController < ApplicationController
  #before_filter :authenticate_user!

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
    ua = request.env["HTTP_USER_AGENT"]
    if ua.include?('Mobile') || ua.include?('Android')
      # スマートフォンは全画面で表示
      full_window
    else
      _take_gallery_data
    end
  end

  def full_window
    _full_window
  end

  def embed
    _full_window
  end

  def _take_gallery_data
    @access_token = params.require(Const::Gallery::Key::GALLERY_ACCESS_TOKEN)
    # ViewCountをupdate
    Gallery.add_view_statistic_count(@access_token, Date.today)
    # データを取得
    @pagevalues, @message, @title, @caption, @screen_size, @creator, @item_js_list, @gallery_view_count, @gallery_bookmark_count, @show_options, @embed_link = Gallery.firstload_contents(@access_token, request.host)
  end

  def _full_window
    _take_gallery_data
    render layout: 'application'
  end

  def save_state
    user_id = current_or_guest_user.id
    tags = params.fetch(Const::Gallery::Key::TAGS, '').split(',').map{|t| ApplicationController.helpers.sanitize(t)}
    title = params.require(Const::Gallery::Key::TITLE).force_encoding('utf-8')
    project_id = params.require(Const::Gallery::Key::PROJECT_ID).to_i
    caption = params.fetch(Const::Gallery::Key::CAPTION, '').force_encoding('utf-8')
    thumbnail_img = params.require(Const::Gallery::Key::THUMBNAIL_IMG)
    thumbnail_img_contents_type = params.require(Const::Gallery::Key::THUMBNAIL_IMG_CONTENTSTYPE)
    thumbnail_img_width = params.require(Const::Gallery::Key::THUMBNAIL_IMG_WIDTH)
    thumbnail_img_height = params.require(Const::Gallery::Key::THUMBNAIL_IMG_HEIGHT)
    page_max = params.require(Const::Gallery::Key::PAGE_MAX)
    show_guide = params.fetch(Const::Gallery::Key::SHOW_GUIDE, false)
    show_page_num = params.fetch(Const::Gallery::Key::SHOW_PAGE_NUM, false)
    show_chapter_num = params.fetch(Const::Gallery::Key::SHOW_CHAPTER_NUM, false)
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
        show_chapter_num)
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
    note = params[Const::Gallery::Key::NOTE]
    Gallery.add_bookmark(user_id, gallery_access_token, note, Date.today)
  end

  def thumbnail
    g = Gallery.find_by(access_token: params[:access_token], del_flg: false)
    if g.blank? || g.thumbnail_img.blank?
      ActionController::Base.helpers.asset_path('image_notfound.png')
    else
      send_data(g.thumbnail_img, type: g.thumbnail_img_contents_type, disposition: :inline)
    end
  end

  private :_take_gallery_data, :_full_window

end
