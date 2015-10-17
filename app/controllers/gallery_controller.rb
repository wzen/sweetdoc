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

    @pagevalues = nil
  end

  def detail
    # Constantの設定
    init_const

    access_token = params[:access_token]
    # ViewCountをupdate
    Gallery.add_view_statistic_count(access_token, Date.today)
    # データを取得
    @pagevalues, @message, @title, @caption, @creator, @item_js_list, @gallery_view_count, @gallery_bookmark_count = Gallery.firstload_contents(access_token)
  end

  def run_window
    # Constantの設定
    init_const
  end

  def save_state
    user_id = current_or_guest_user.id
    tags = params[Const::Gallery::Key::TAGS]
    title = params[Const::Gallery::Key::TITLE]
    project_id = params[Const::Gallery::Key::PROJECT_ID]
    if project_id == nil || title == nil || title.length == 0
      # エラー
      @message, @access_token = I18n.t('message.database.item_state.save.error')
    else
      project_id = project_id.to_i
      caption = params[Const::Gallery::Key::CAPTION]
      thumbnail_img = params[Const::Gallery::Key::THUMBNAIL_IMG]
      page_max = params[Const::Gallery::Key::PAGE_MAX]
      show_guide = params[Const::Gallery::Key::SHOW_GUIDE]
      show_page_num = params[Const::Gallery::Key::SHOW_PAGE_NUM]
      show_chapter_num = params[Const::Gallery::Key::SHOW_CHAPTER_NUM]
      @message, @access_token = Gallery.save_state(user_id, project_id, tags, title, caption, thumbnail_img, page_max, show_guide, show_page_num, show_chapter_num)
    end
  end

  def update_last_state
    user_id = current_or_guest_user.id
    tags = params[Const::Gallery::Key::TAGS]
    i_page_values = params[Const::Gallery::Key::INSTANCE_PAGE_VALUE]
    e_page_values = params[Const::Gallery::Key::EVENT_PAGE_VALUE]
    @message = Gallery.update_last_state(user_id, tags, i_page_values, e_page_values)
  end

  def get_contents
    show_head = params[Const::Gallery::SearchKey::SHOW_HEAD].to_i
    show_limit = params[Const::Gallery::SearchKey::SHOW_LIMIT].to_i
    search_type = params[Const::Gallery::SearchKey::SEARCH_TYPE]
    tag_id = params[Const::Gallery::SearchKey::TAG_ID].to_i
    date = params[Const::Gallery::SearchKey::DATE]
    if search_type == Const::Gallery::SearchType::CREATED
      @contents = Gallery.grid_contents_sorted_by_createdate(show_head, show_limit, tag_id)
    elsif search_type == Const::Gallery::SearchType::VIEW_COUNT
      @contents = Gallery.grid_contents_sorted_by_viewcount(show_head, show_limit, date, tag_id)
    elsif search_type == Const::Gallery::SearchType::BOOKMARK_COUNT
      @contents = Gallery.grid_contents_sorted_by_bookmarkcount(show_head, show_limit, date, tag_id)
    end
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

end
