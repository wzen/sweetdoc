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

    access_token = params[:access_token]
    # ViewCountをupdate
    Gallery.add_view_statistic_count(access_token, Date.today)
    # データを取得
    @pagevalues, @message, @title, @caption, @creator, @item_js_list, @gallery_view_count, @gallery_bookmark_count, @show_options = Gallery.firstload_contents(access_token)
  end

  def run_window
    # Constantの設定
    init_const
  end

  def save_state
    user_id = current_or_guest_user.id
    tags = params[Const::Gallery::Key::TAGS].split(',')
    title = params[Const::Gallery::Key::TITLE].force_encoding('utf-8')
    project_id = params[Const::Gallery::Key::PROJECT_ID]
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
      @message, @access_token = Gallery.save_state(
          user_id,
          project_id,
          tags,
          title,
          caption,
          thumbnail_img,
          thumbnail_img_contents_type,
          page_max,
          show_guide,
          show_page_num,
          show_chapter_num)
    end
  end

  def update_last_state
    user_id = current_or_guest_user.id
    tags = params[Const::Gallery::Key::TAGS]
    i_page_values = params[Const::Gallery::Key::INSTANCE_PAGE_VALUE]
    e_page_values = params[Const::Gallery::Key::EVENT_PAGE_VALUE]
    @message = Gallery.update_last_state(user_id, tags, i_page_values, e_page_values)
  end

  def get_contents(show_head, show_limit, tag_id)
    show_head = params[Const::Gallery::SearchKey::SHOW_HEAD].to_i
    show_limit = params[Const::Gallery::SearchKey::SHOW_LIMIT].to_i
    search_type = params[Const::Gallery::SearchKey::SEARCH_TYPE]
    tag_id = params[Const::Gallery::SearchKey::TAG_ID].to_i
    date = params[Const::Gallery::SearchKey::DATE]
    contents = Gallery.get_list_contents(search_type, show_head, show_limit, tag_id, date)
    @contents = contents.uniq{|u| u[Const::Gallery::Key::GALLERY_ACCESS_TOKEN]}
  end

  def get_popular_and_recommend_tags
    recommend_source_word = params[Const::Gallery::Key::RECOMMEND_SOURCE_WORD]
    @popular_tags = GalleryTag.get_popular_tags
    @recommend_tags = GalleryTag.get_recommend_tags(@popular_tags, recommend_source_word)
  end

  def add_bookmark
    user_id = current_or_guest_user.id
    gallery_access_token = params[Const::Gallery::Key::GALLERY_ACCESS_TOKEN]
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
