class GalleryController < ApplicationController
  def index

  end

  def save_state
    user_id = current_user.id
    tags = params[Const::Gallery::Key::TAGS]
    i_page_values = params[Const::Gallery::Key::INSTANCE_PAGE_VALUE]
    e_page_values = params[Const::Gallery::Key::EVENT_PAGE_VALUE]
    @message = Gallery.save_state(user_id, tags, i_page_values, e_page_values)
  end

  def update_last_state
    user_id = current_user.id
    tags = params[Const::Gallery::Key::TAGS]
    i_page_values = params[Const::Gallery::Key::INSTANCE_PAGE_VALUE]
    e_page_values = params[Const::Gallery::Key::EVENT_PAGE_VALUE]
    @message = Gallery.update_last_state(user_id, tags, i_page_values, e_page_values)
  end

  def load_data
    user_id = current_user.id
    @item_js_list, @instance_pagevalue_data, @event_pagevalue_data, @message = Gallery.load_state(user_id)
  end

  def grid_contents
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

  def get_recommend_tags

  end

end
