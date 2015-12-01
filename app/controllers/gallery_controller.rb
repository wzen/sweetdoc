require 'gallery/gallery'

class GalleryController < ApplicationController
  #before_filter :authenticate_user!

  def index
    # Constantの設定
    init_const
  end

  def grid
    # Constantの設定
    init_const

    # ブックマークしたコンテンツ & タグからの関連コンテンツ & 今日のアクセスTopコンテンツ
    show_head = 0
    show_limit = 50
    tag_ids = Gallery.get_bookmarked_tag(current_or_guest_user.id)
    date = Date.today
    contents = Gallery.grid_index(show_head, show_limit, date, tag_ids)
    @contents = contents.uniq{|u| u[Const::Gallery::Key::GALLERY_ACCESS_TOKEN]}
  end

  def detail
    # Constantの設定
    init_const

    access_token = params.require(Const::Gallery::Key::GALLERY_ACCESS_TOKEN)
    # ViewCountをupdate
    Gallery.add_view_statistic_count(access_token, Date.today)
    # データを取得
    @pagevalues, @message, @title, @caption, @creator, @item_js_list, @gallery_view_count, @gallery_bookmark_count, @show_options = Gallery.firstload_contents(access_token)
  end

  def run_window
    # Constantの設定
    init_const

    access_token = params.require(Const::Gallery::Key::GALLERY_ACCESS_TOKEN)
    # ViewCountをupdate
    Gallery.add_view_statistic_count(access_token, Date.today)
    # データを取得
    @pagevalues, @message, @title, @caption, @creator, @item_js_list, @gallery_view_count, @gallery_bookmark_count, @show_options = Gallery.firstload_contents(access_token)
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
    g = Gallery.find_by(access_token: params[:access_token])
    if g == nil || g.thumbnail_img == nil
      ActionController::Base.helpers.asset_path('image_notfound.png')
    else
      send_data(g.thumbnail_img, type: g.thumbnail_img_contents_type, disposition: :inline)
    end
  end

end
