class GalleryGridContents
  def initialize(page, date, tag_ids, filter_type)
    @page = page.to_i
    @limit = 30
    @date = date
    @tag_ids = tag_ids
    @filter_type = filter_type
  end

  def current_page
    @page
  end

  def total_pages
    ret = execute(to_total_count_sql)
    if ret.present? && ret[0].first.present?
      return ret[0].first[1]
    else
      0
    end
  end

  def limit_value
    @limit
  end

  def offset
    (@page - 1) * @limit
  end

  def all
    execute(to_sql)
  end

  def execute(sql)
    begin
      ActiveRecord::Base.transaction do
        contents = ActiveRecord::Base.connection.select_all(sql)
        if contents.present? && contents.count > 0
          contents = contents.to_hash
          if @filter_type == Const::Gallery::SearchType::ALL
            # 同じコンテンツを除外
            contents = contents.uniq{|u| u[Const::Gallery::Key::GALLERY_ACCESS_TOKEN]}
          end
          return contents
        end
        return {}
      end
    rescue => e
      # 失敗
      return {}
    end
  end

  def to_sql
    sql = nil
    # TODO: リコメンド取得追加
    if @filter_type == Const::Gallery::SearchType::ALL
      sql =<<-"SQL"
        (#{grid_contents_sorted_by_createdate_sql})
        UNION ALL
        (#{grid_contents_sorted_by_viewcount_sql})
        UNION ALL
        (#{grid_contents_sorted_by_bookmarkcount_sql})
      SQL
    elsif @filter_type == Const::Gallery::SearchType::CREATED
      sql = grid_contents_sorted_by_createdate_sql
    elsif @filter_type == Const::Gallery::SearchType::VIEW_COUNT
      sql = grid_contents_sorted_by_viewcount_sql
    elsif @filter_type == Const::Gallery::SearchType::BOOKMARK_COUNT
      sql = grid_contents_sorted_by_bookmarkcount_sql
    end
    sql
  end

  def to_total_count_sql
    sql = nil
    # TODO: リコメンド取得追加
    if @filter_type == Const::Gallery::SearchType::ALL
      sql =<<-"SQL"
        (#{total_count_by_createdate_sql})
        UNION ALL
        (#{total_count_by_viewcount_sql})
        UNION ALL
        (#{total_count_by_bookmarkcount_sql})
      SQL
    elsif @filter_type == Const::Gallery::SearchType::CREATED
      sql = total_count_by_createdate_sql
    elsif @filter_type == Const::Gallery::SearchType::VIEW_COUNT
      sql = total_count_by_viewcount_sql
    elsif @filter_type == Const::Gallery::SearchType::BOOKMARK_COUNT
      sql = total_count_by_bookmarkcount_sql
    end
    sql
  end

  def grid_contents_select(search_type)
    return <<-"VALUE"
      g.access_token as #{Const::Gallery::Key::GALLERY_ACCESS_TOKEN},
      g.title as #{Const::Gallery::Key::TITLE},
      g.caption as #{Const::Gallery::Key::CAPTION},
      g.thumbnail_img as #{Const::Gallery::Key::THUMBNAIL_IMG},
      g.thumbnail_img_width as #{Const::Gallery::Key::THUMBNAIL_IMG_WIDTH},
      g.thumbnail_img_height as #{Const::Gallery::Key::THUMBNAIL_IMG_HEIGHT},
      g.screen_width as #{Const::Gallery::Key::SCREEN_SIZE_WIDTH},
      g.screen_height as #{Const::Gallery::Key::SCREEN_SIZE_HEIGHT},
      '#{search_type}' as #{Const::Gallery::Key::SEARCH_TYPE}
    VALUE
  end

  def grid_contents_sorted_by_createdate_sql
    _createdate_sql
  end

  def total_count_by_createdate_sql
    _createdate_sql(true)
  end

  def grid_contents_sorted_by_viewcount_sql
    _viewcount_sql
  end

  def total_count_by_viewcount_sql
    _viewcount_sql(true)
  end

  def grid_contents_sorted_by_bookmarkcount_sql
    _bookmarkcount_sql
  end

  def total_count_by_bookmarkcount_sql
    _bookmarkcount_sql(true)
  end

  private
  def _bookmarkcount_sql(total_count = false)
    where = 'WHERE g.del_flg = 0'
    if @date.present?
      where += " AND DATEDIFF(#{@date}, gbs.view_day) = 0"
    end
    if @tag_ids.present? && @tag_ids.length > 0
      tags_in = "(#{@tag_ids.join(',')})"
      where += " AND gt.id IN #{tags_in}"
    end
    select = total_count ? 'count(*)' : grid_contents_select(Const::Gallery::SearchType::BOOKMARK_COUNT)
    sql =<<-"SQL"
      SELECT #{select}
      FROM galleries g
      INNER JOIN users u ON g.created_user_id = u.id
      INNER JOIN gallery_bookmark_statistics as gbs ON g.id = gbs.gallery_id AND gbs.del_flg = 0
      LEFT JOIN gallery_tag_maps as gtm ON g.id = gtm.gallery_id AND gtm.del_flg = 0
      LEFT JOIN gallery_tags as gt ON gtm.gallery_tag_id = gt.id AND gt.del_flg = 0
      #{where}
      ORDER BY gbs.count DESC LIMIT #{offset}, #{@limit}
    SQL
    sql
  end
  def _viewcount_sql(total_count = false)
    where = 'WHERE g.del_flg = 0'
    if @date.present?
      where += " AND DATEDIFF(#{@date}, gbs.view_day) = 0"
    end
    if @tag_ids.present? && @tag_ids.length > 0
      tags_in = "(#{@tag_ids.join(',')})"
      where += " AND gt.id IN #{tags_in}"
    end
    select = total_count ? 'count(*)' : grid_contents_select(Const::Gallery::SearchType::VIEW_COUNT)
    sql =<<-"SQL"
      SELECT #{select}
      FROM galleries g
      INNER JOIN users u ON g.created_user_id = u.id
      INNER JOIN gallery_view_statistics as gbs ON g.id = gbs.gallery_id AND gbs.del_flg = 0
      LEFT JOIN gallery_tag_maps as gtm ON g.id = gtm.gallery_id AND gtm.del_flg = 0
      LEFT JOIN gallery_tags as gt ON gtm.gallery_tag_id = gt.id AND gt.del_flg = 0
      #{where}
      ORDER BY gbs.count DESC LIMIT #{offset}, #{@limit}
    SQL
    sql
  end
  def _createdate_sql(total_count = false)
    table = nil
    if @tag_ids.present? && @tag_ids.length > 0
      tags_in = "(#{@tag_ids.join(',')})"
      table =<<-"TABLE"
        (
        SELECT g2.*
        FROM galleries g2
        LEFT JOIN gallery_tag_maps as gtm2 ON g2.id = gtm2.gallery_id AND gtm2.del_flg = 0
        LEFT JOIN gallery_tags as gt2 ON gtm2.gallery_tag_id = gt2.id AND gt2.del_flg = 0
        WHERE gt2.id IN #{tags_in}
        AND g2.del_flg = 0
        ORDER BY g.created_at DESC LIMIT #{offset}, #{@limit}
        )
      TABLE
    else
      table = "(SELECT * FROM galleries WHERE del_flg = 0 ORDER BY created_at DESC LIMIT #{offset}, #{@limit})"
    end
    select = total_count ? 'count(*)' : grid_contents_select(Const::Gallery::SearchType::CREATED)
    sql =<<-"SQL"
     SELECT #{select}
     FROM #{table} g
      INNER JOIN users u ON g.created_user_id = u.id
     LEFT JOIN gallery_tag_maps as gtm ON g.id = gtm.gallery_id AND gtm.del_flg = 0
     LEFT JOIN gallery_tags as gt ON gtm.gallery_tag_id = gt.id AND gt.del_flg = 0
     WHERE g.del_flg = 0
    SQL
    sql
  end
end