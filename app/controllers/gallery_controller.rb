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

  def load_data(limit)

  end

  def get_recommend_tags

  end

end
