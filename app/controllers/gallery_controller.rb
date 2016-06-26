class GalleryController < ApplicationController
  #before_action :authenticate_user!

  include GalleryConcern::Get
  include GalleryConcern::Save

  def index
  end

  def grid
    _get_grid_contents(params[:page] || 1)
    @total_count = @ggc.total_pages
  end

  def grid_ajax
    # ブックマークしたコンテンツ & タグからの関連コンテンツ & 今日のアクセスTopコンテンツ
    page = params[:page]
    if page.present?
      _get_grid_contents(page)
    end
    render layout: false
  end

  def get_info
    user_id = current_or_guest_user.id
    @access_token = params.require(Const::Gallery::Key::GALLERY_ACCESS_TOKEN)
    g = get_gallery_contents_with_tags(user_id, @access_token).first
    render json: g.present? ? g : nil
  end

  def _get_grid_contents(page)
    # ブックマークしたコンテンツ & タグからの関連コンテンツ & 今日のアクセスTopコンテンツ
    @filter_type = params.fetch(Const::Gallery::Key::FILTER_TYPE, Const::Gallery::SearchType::ALL)
    if @filter_type.blank?
      @filter_type = Const::Gallery::SearchType::ALL
    end
    @filter_date = params.fetch(Const::Gallery::Key::FILTER_DATE, nil)
    @filter_tags = params.fetch(Const::Gallery::Key::FILTER_TAGS, nil)
    @word = params.fetch(Const::Gallery::Key::WORD, nil)
    @ggc = GalleryGridContents.new(page, @filter_date, @filter_tags, @filter_type, @word)
    @contents = @ggc.all
    @dummy_contents_length = 0
    if @contents.length < Const::GRID_CONTENTS_DISPLAY_MIN
      @dummy_contents_length = Const::GRID_CONTENTS_DISPLAY_MIN - @contents.length
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
    @access_token = params.require(Const::Gallery::Key::GALLERY_ACCESS_TOKEN)
    g = Gallery.find_by(access_token: @access_token)
    @is_exist_gallery = g.present?
    if @is_exist_gallery
      @title = g.title
      @caption = g.caption
      @thumbnail_url = g.thumbnail_url
      ret, message, @creator = get_gallery_creator_info_by_gallery_id(g.id)
    end
    render layout: 'gallery_fullwindow'
  end
  def embed_with_run
    _take_gallery_data
    render layout: 'gallery_fullwindow'
  end

  def _take_gallery_data
    user_id = current_or_guest_user.id
    @access_token = params.require(Const::Gallery::Key::GALLERY_ACCESS_TOKEN)
    # ViewCountをupdate
    add_gallery_view_statistic_count(@access_token, Date.today)
    # データを取得
    @pagevalues, @message, @title, @caption, @screen_size, @creator, @item_js_list, @gallery_view_count, @gallery_bookmark_count, @show_options, @string_link, @embed_link, @bookmarked, @tags = firstload_gallery_contents(user_id, @access_token, request.host)
  end

  def save_state
    user_id = current_or_guest_user.id
    tags = params.fetch(Const::Gallery::Key::TAGS, '').split(',').map{|t| ApplicationController.helpers.sanitize(t)}
    title = params.require(Const::Gallery::Key::TITLE).force_encoding('utf-8')
    project_id = params.require(Const::Gallery::Key::PROJECT_ID).to_i
    caption = params.fetch(Const::Gallery::Key::CAPTION, '').force_encoding('utf-8')
    thumbnail_img = params.fetch(Const::Gallery::Key::THUMBNAIL_IMG, nil)
    if thumbnail_img.present? && thumbnail_img.size > 1000 * Const::THUMBNAIL_FILESIZE_MAX_KB
      @result_success, @message = false, ""
      return
    end
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
    @result_success, @message, @access_token = save_gallery_state(
        user_id,
        project_id,
        tags,
        ApplicationController.helpers.sanitize(title),
        ApplicationController.helpers.sanitize(caption),
        thumbnail_img,
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
    @result_success, @message = update_gallery_last_state(user_id, tags, i_page_values, e_page_values)
  end

  def get_popular_and_recommend_tags
    recommend_source_word = params.require(Const::Gallery::Key::RECOMMEND_SOURCE_WORD)
    @popular_tags = get_popular_gallery_tags
    @recommend_tags = get_recommend_gallery_tags(@popular_tags, recommend_source_word)
  end

  def add_bookmark
    user_id = current_or_guest_user.id
    gallery_access_token = params.require(Const::Gallery::Key::GALLERY_ACCESS_TOKEN)
    note = params.fetch(Const::Gallery::Key::NOTE, '')
    @result_success, @message = add_gallery_bookmark(user_id, gallery_access_token, note, Date.today)
  end

  def remove_bookmark
    user_id = current_or_guest_user.id
    gallery_access_token = params.require(Const::Gallery::Key::GALLERY_ACCESS_TOKEN)
    @result_success, @message = remove_gallery_bookmark(user_id, gallery_access_token, Date.today)
  end

  private :_take_gallery_data, :_get_grid_contents

end
