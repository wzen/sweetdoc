class GalleryController < ApplicationController
  def index

  end

  def grid
    @contents = nil
  end

  def detail
    galiery_id = params[Const::Gallery::Key::GALLERY_ID]
    # ViewCountをupdate
    Gallery.add_view_statistic_count(galiery_id, Date.today)
    # データを取得
    @contents_detail = Gallery.load_contents_detail(galiery_id)
  end

  def save_state
    user_id = current_user.id
    tags = params[Const::Gallery::Key::TAGS]
    title = params[Const::Gallery::Key::TITLE]
    if title == nil || title.length == 0
      # エラー
      @message = I18n.t('message.database.item_state.save.error')
      render
    end

    caption = params[Const::Gallery::Key::CAPTION]
    thumbnail_img = params[Const::Gallery::Key::THUMBNAIL_IMG]
    i_page_values = params[Const::Gallery::Key::INSTANCE_PAGE_VALUE]
    e_page_values = params[Const::Gallery::Key::EVENT_PAGE_VALUE]
    @message = Gallery.save_state(user_id, tags, title, caption, thumbnail_img, i_page_values, e_page_values)
  end

  def update_last_state
    user_id = current_user.id
    tags = params[Const::Gallery::Key::TAGS]
    i_page_values = params[Const::Gallery::Key::INSTANCE_PAGE_VALUE]
    e_page_values = params[Const::Gallery::Key::EVENT_PAGE_VALUE]
    @message = Gallery.update_last_state(user_id, tags, i_page_values, e_page_values)
  end

  def load_state
    user_id = current_user.id
    galiery_id = params[Const::Gallery::Key::GALLERY_ID]
    @contents_detail = Gallery.load_state(galiery_id, user_id)
  end

  def get_contents
    show_head = params[Const::Gallery::SearchKey::SHOW_HEAD]
    show_limit = params[Const::Gallery::SearchKey::SHOW_LIMIT]
    search_type = params[Const::Gallery::SearchKey::SEARCH_TYPE]
    tag_id = params[Const::Gallery::SearchKey::TAG_ID]
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
    user_id = current_user.id
    galiery_id = params[Const::Gallery::Key::GALLERY_ID]
    note = params[Const::Gallery::Key::NOTE]
    Gallery.add_bookmark(user_id, galiery_id, note, Date.today)
  end

end
