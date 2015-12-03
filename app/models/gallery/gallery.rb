require 'xmlrpc/client'
require 'project/project'
require 'project/project_gallery_map'
require 'project/user_project_map'
require 'gallery/gallery_tag'
require 'gallery/gallery_tag_map'
require 'gallery/gallery_general_pagevalue'
require 'gallery/gallery_general_pagevalue_paging'
require 'gallery/gallery_instance_pagevalue'
require 'gallery/gallery_instance_pagevalue_paging'
require 'gallery/gallery_event_pagevalue'
require 'gallery/gallery_event_pagevalue_paging'
require 'gallery/gallery_view_statistic'
require 'gallery/gallery_bookmark'
require 'gallery/gallery_bookmark_statistic'
require 'pagevalue/page_value_state'
require 'item/preload_item'

class Gallery < ActiveRecord::Base
  belongs_to :user_project_map
  has_many :gallery_instance_pagevalue_pagings
  has_many :gallery_event_pagevalue_pagings
  has_many :gallery_tag_maps
  has_many :gallery_bookmarks
  has_many :gallery_view_statistics
  has_many :gallery_bookmark_statistics
  has_many :projects
  has_many :project_gallery_mapsX

  def self.save_state(
    user_id,
    project_id,
    tags,
    title,
    caption,
    thumbnail_img,
    thumbnail_img_contents_type,
    thumbnail_width,
    thumbnail_height,
    page_max,
    show_guide,
    show_page_num,
    show_chapter_num
  )
    begin
      ActiveRecord::Base.transaction do
        # Project取得
        p = Project.find(project_id)
        # Gallery レコード追加
        g = self.new({
                         access_token: SecureRandom.uuid,
                         title: title,
                         caption: caption,
                         thumbnail_img: Base64.decode64(thumbnail_img),
                         thumbnail_img_contents_type: thumbnail_img_contents_type,
                         thumbnail_img_width: thumbnail_width,
                         thumbnail_img_height: thumbnail_height,
                         page_max: page_max,
                         screen_width: p.screen_width,
                         screen_height: p.screen_height,
                         show_guide: show_guide,
                         show_page_num: show_page_num,
                         show_chapter_num: show_chapter_num
                     })
        g.save!
        gallery_id = g.id

        # UserProjectMap取得
        upm = UserProjectMap.find_by(user_id: user_id, project_id: project_id)
        # ProjectGalelryMap追加
        pgm = ProjectGalleryMap.new({user_project_map_id: upm.id, gallery_id: g.id})
        pgm.save!


        # Pagevalueレコード取得
        sql = <<-"SQL"
          SELECT gp.data as g_pagevalue_data, ip.data as i_pagevalue_data, ep.data as e_pagevalue_data, gpp.page_num as page_num
          FROM user_pagevalues up
          LEFT JOIN general_pagevalue_pagings gpp ON up.id = gpp.user_pagevalue_id AND gpp.del_flg = 0
          LEFT JOIN general_pagevalues gp ON gpp.general_pagevalue_id = gp.id AND gp.del_flg = 0
          LEFT JOIN instance_pagevalue_pagings ipp ON up.id = ipp.user_pagevalue_id AND ipp.page_num = gpp.page_num AND ipp.del_flg = 0
          LEFT JOIN instance_pagevalues ip ON ipp.instance_pagevalue_id = ip.id AND ip.del_flg = 0
          LEFT JOIN event_pagevalue_pagings epp ON up.id = epp.user_pagevalue_id AND ipp.page_num = epp.page_num AND epp.del_flg = 0
          LEFT JOIN event_pagevalues ep ON epp.event_pagevalue_id = ep.id AND ep.del_flg = 0
          WHERE
            up.user_project_map_id = #{upm.id}
          AND
            up.del_flg = 0
        SQL
        ret = ActiveRecord::Base.connection.select_all(sql).to_hash
        ret.each do |record|
          page_num = record['page_num']
          g_pagevalue_data = record['g_pagevalue_data']
          if g_pagevalue_data.present?
            gp = GalleryGeneralPagevalue.new({data: g_pagevalue_data})
            gp.save!
            gpp = GalleryGeneralPagevaluePaging.new({
                                                         gallery_id: gallery_id,
                                                         page_num: page_num,
                                                         gallery_general_pagevalue_id: gp.id
                                                     })
            gpp.save!
          end

          i_pagevalue_data = record['i_pagevalue_data']
          if i_pagevalue_data.present?
            ip = GalleryInstancePagevalue.new({data: i_pagevalue_data})
            ip.save!
            ipp = GalleryInstancePagevaluePaging.new({
                                                         gallery_id: gallery_id,
                                                         page_num: page_num,
                                                         gallery_instance_pagevalue_id: ip.id
                                                     })
            ipp.save!
          end

          e_pagevalue_data = record['e_pagevalue_data']
          if e_pagevalue_data.present?
            ep = GalleryEventPagevalue.new({data: e_pagevalue_data})
            ep.save!
            epp = GalleryEventPagevaluePaging.new({
                                                      gallery_id: gallery_id,
                                                      page_num: page_num,
                                                      gallery_event_pagevalue_id: ep.id
                                                  })
            epp.save!
          end
        end

        # Tag レコード追加
        save_tag(tags, gallery_id)

        return true, I18n.t('message.database.item_state.save.success'), g.access_token
      end
    rescue => e
      # 更新失敗
      return false, I18n.t('message.database.item_state.save.error'), nil
    end
  end

  def self.add_view_statistic_count(access_token, date)
    begin
      g = self.find_by({access_token: access_token, del_flg: false})
      gvs = GalleryViewStatistic.where({gallery_id: g.id, view_day: date}).first
      if gvs.blank?
        # 新規作成
        gvs = GalleryViewStatistic.new({
                                           gallery_id: g.id,
                                           view_day: date
                                       })
      else
        gvs.count += 1
      end
      gvs.save!
    rescue => e
      # 更新失敗
      return I18n.t('message.database.item_state.save.error')
    end
  end

  def self.add_bookmark(user_id, gallery_access_token, note, date)
    begin
      ActiveRecord::Base.transaction do
        g = self.find_by({access_token: gallery_access_token, del_flg: false})
        gallery_id = g.id
        gb = GalleryBookmark.where({gallery_id: gallery_id, user_id: user_id})
        # 既にブックマークが存在する場合は処理なし
        if gb.blank?
          gb = GalleryBookmark.new({
                                       gallery_id: gallery_id,
                                       user_id: user_id,
                                       note: note
                                   })
          gb.save!

          gbs = GalleryBookmarkStatistic.where({gallery_id: gallery_id, view_day: date})
          if gbs.blank?
            # 新規作成
            gbs = GalleryBookmarkStatistic.new({
                                                   gallery_id: gallery_id,
                                                   view_day: date
                                               })
          else
            gbs.count += 1
          end
          gbs.save!
        end
      end
    rescue => e
      # 更新失敗
      return I18n.t('message.database.item_state.save.error')
    end
  end


  def self.update_last_state(user_id, tags, i_page_values, e_page_values)
    begin
      if i_page_values != 'null' && e_page_values != 'null'

        ActiveRecord::Base.transaction do
          # Instance 最新データ取得
          last_i_page_values = GalleryInstancePagevaluePaging.joins(:gallery).where(gallery: {user_id: user_id})

          # Instance 追加 or 更新
          i_page_values.each do |k, v|
            page_num = v['pageNum']
            pagevalue = v['pagevalue']

            p = last_i_page_values.map{|m| m.page_num.to_i == page_num}.first
            if p.blank?
              # Insert
              ip = GalleryInstancePagevalue.new({data: pagevalue})
              ip.save!
              ipp = GalleryInstancePagevaluePaging.new({
                                                    gallery_id: gallery_id,
                                                    page_num: page_num,
                                                    instance_pagevalue_id: ip.id
                                                })
              ipp.save!

            else
              # Update
              ip = GalleryInstancePagevalue.find(p.gallery_instance_pagevalue_id.to_i)
              if ip.present?
                ip.data = pagevalue
              end
              ip.save!

            end
          end

          # Instance 不要なレコードの削除フラグを立てる
          extras = last_i_page_values.map{|m| m.page_num.to_i > i_page_values.length}
          extras.each do |extra|
            ip = GalleryInstancePagevalue.find(extra.gallery_instance_pagevalue_id.to_i)
            if ip.present?
              if ip.retain <= 1
                ip.del_flg = true
              end
              ip.retain -= 1
              ip.save!
            end
            ipp = GalleryInstancePagevaluePaging.find(extra.id.to_i)
            if ipp.present?
              ipp.del_flg = true
              ipp.save!
            end
          end

          # Event 最新データ取得
          last_e_page_values = GalleryEventPagevaluePaging.joins(:gallery).where(gallery: {user_id: user_id})

          # Event 追加 or 更新
          e_page_values.each do |k, v|
            page_num = v['pageNum']
            pagevalue = v['pagevalue']

            p = last_e_page_values.map{|m| m.page_num.to_i == page_num}.first
            if p.blank?
              # Insert
              ep = GalleryEventPagevalue.new({data: pagevalue})
              ep.save!
              epp = GalleryEventPagevaluePaging.new({
                                                           gallery_id: gallery_id,
                                                           page_num: page_num,
                                                           event_pagevalue_id: ep.id
                                                       })
              epp.save!

            else
              # Update
              ep = GalleryInstancePagevalue.find(p.gallery_event_pagevalue_id.to_i)
              if ep.present?
                ep.data = pagevalue
              end
              ep.save!

            end
          end

          # Event 不要なレコードの削除フラグを立てる
          extras = last_e_page_values.map{|m| m.page_num.to_i > e_page_values.length}
          extras.each do |extra|
            ep = GalleryEventPagevalue.find(extra.gallery_event_pagevalue_id.to_i)
            if ep.present?
              if ep.retain <= 1
                ep.del_flg = true
              end
              ep.retain -= 1
              ep.save!
            end
            epp = GalleryEventPagevaluePaging.find(extra.id.to_i)
            if epp.present?
              epp.del_flg = true
              epp.save!
            end
          end

          # Tag レコード追加
          save_tag(tags, gallery_id)

        end
      end

      return true, I18n.t('message.database.item_state.save.success')
    rescue => e
      # 更新失敗
      return false, I18n.t('message.database.item_state.save.error')
    end
  end

  # タグ名のレコードを新規作成
  def self.save_tag(tags, gallery_id)
    begin
      if tags != 'null' && tags.length > 0
        # タグ数がMAX以上のものは削除
        tags = tags.take(Const::Gallery::TAG_MAX)

        # タグテーブル処理
        tag_ids = []
        tags.each do |tag|
          t = GalleryTag.find_by(name: tag)
          if t.blank?
            # タグを新規作成
            t = GalleryTag.new({
                                     name: tag
                                 })
            t.save!
            tag_ids << t.id

          else
            # タグの重み付けを加算
            if t.weight
              t.weight += 1
            else
              t.weight = 1
            end

            t.save!
            tag_ids << t.id
          end
        end

        # 存在しているデータが有る場合削除
        GalleryTagMap.delete_all(gallery_id: gallery_id)

        # タグマップテーブル作成
        tag_ids.each do |tag_id|
          # Insert
          map = GalleryTagMap.new({
                                      gallery_id: gallery_id,
                                      gallery_tag_id: tag_id
                                  })
          map.save!
        end

        # タグカテゴリ設定
        GalleryTag.save_tag_category(tags)
      end

    rescue => e
      raise e
    end
  end

  def self.firstload_contents(access_token, page_num = 1)
    sql = <<-"SQL".strip_heredoc
      SELECT
        g.title as title,
        g.caption as caption,
        g.screen_width as screen_width,
        g.screen_height as screen_height,
        g.page_max as page_max,
        g.show_guide as show_guide,
        g.show_page_num as show_page_num,
        g.show_chapter_num as show_chapter_num,
        u.id as user_id,
        u.name as username,
        u.thumbnail_img as user_thumbnail_img,
        ggp.data as general_pagevalue_data,
        gip.data as instance_pagevalue_data,
        gep.data as event_pagevalue_data,
        gbs.count as bookmark_count,
        gvs.count as view_count,
        ugf.page_num as footprint_page_num
      FROM galleries g
      INNER JOIN project_gallery_maps pgm ON g.id = pgm.gallery_id
      INNER JOIN user_project_maps upm ON pgm.user_project_map_id = upm.id
      INNER JOIN users u ON upm.user_id = u.id
      LEFT JOIN gallery_general_pagevalue_pagings ggpp ON g.id = ggpp.gallery_id AND ggpp.page_num = #{page_num} AND ggpp.del_flg = 0
      LEFT JOIN gallery_general_pagevalues ggp ON ggpp.gallery_general_pagevalue_id = ggp.id AND ggp.del_flg = 0
      LEFT JOIN gallery_instance_pagevalue_pagings gipp ON g.id = gipp.gallery_id AND gipp.page_num = ggpp.page_num AND gipp.del_flg = 0
      LEFT JOIN gallery_instance_pagevalues gip ON gipp.gallery_instance_pagevalue_id = gip.id AND gip.del_flg = 0
      LEFT JOIN gallery_event_pagevalue_pagings gepp ON g.id = gepp.gallery_id AND gipp.page_num = gepp.page_num AND gepp.del_flg = 0
      LEFT JOIN gallery_event_pagevalues gep ON gepp.gallery_event_pagevalue_id = gep.id AND gep.del_flg = 0
      LEFT JOIN gallery_bookmark_statistics gbs ON g.id = gbs.gallery_id AND gbs.del_flg = 0
      LEFT JOIN gallery_view_statistics gvs ON g.id = gvs.gallery_id AND gvs.del_flg = 0
      LEFT JOIN user_gallery_footprints ugf ON ugf.user_id = u.id AND ugf.gallery_id = g.id AND ugf.del_flg = 0
      WHERE g.access_token = '#{access_token}'
      AND g.del_flg = 0
      AND pgm.del_flg = 0
      AND upm.del_flg = 0
      AND u.del_flg = 0
      LIMIT 1
    SQL
    ret_sql = ActiveRecord::Base.connection.select_all(sql)
    pagevalues = ret_sql.to_hash
    if pagevalues.count == 0
      message = I18n.t('message.database.item_state.load.error')
      return nil
    else
      pagevalues = pagevalues.first
      gpd = {}
      gpd[Const::Project::Key::SCREEN_SIZE] = {
          width: pagevalues['screen_width'],
          height: pagevalues['screen_height']
      }
      gpd[Const::PageValueKey::PAGE_COUNT] = pagevalues['page_max']
      gpd[Const::PageValueKey::P_PREFIX + page_num.to_s] = JSON.parse(pagevalues['general_pagevalue_data'])
      ipd = {}
      ipd[Const::PageValueKey::P_PREFIX + page_num.to_s] = JSON.parse(pagevalues['instance_pagevalue_data'])
      epd = {}
      epd[Const::PageValueKey::P_PREFIX + page_num.to_s] = JSON.parse(pagevalues['event_pagevalue_data'])
      fpd = {}
      if pagevalues['footprint_page_num'].present?
        fpd[Const::PageValueKey::PAGE_NUM] = pagevalues['footprint_page_num']
      else
        fpd[Const::PageValueKey::PAGE_NUM] = 1
      end

      # 必要なItemIdを調査
      itemids = PageValueState.extract_need_load_itemids(pagevalues['event_pagevalue_data'])
      item_js_list = ItemJs.extract_iteminfo(PreloadItem.find(itemids))

      # 閲覧数 & ブックマーク数を取得
      gallery_view_count = pagevalues['bookmark_count']
      gallery_bookmark_count = pagevalues['view_count']

      pagevalues, creator = Run.setup_data(pagevalues['user_id'].to_i, gpd, ipd, epd, fpd, page_num)

      show_options = {}
      show_options[Const::Gallery::Key::SHOW_GUIDE] = pagevalues['show_guide']
      show_options[Const::Gallery::Key::SHOW_PAGE_NUM] = pagevalues['show_page_num']
      show_options[Const::Gallery::Key::SHOW_CHAPTER_NUM] = pagevalues['show_chapter_num']

      message = I18n.t('message.database.item_state.load.success')

      return pagevalues, message, pagevalues['title'], pagevalues['caption'], creator, item_js_list, gallery_view_count, gallery_bookmark_count, show_options
    end
  end

  def self.paging(user_id, access_token, target_pages, loaded_itemids, load_footprint)
    # TODO: 操作履歴は後でMemcachedに変更予定

    footprint_sql_select = ''
    footprint_sql_from = ''
    if load_footprint
      footprint_sql_select = ', ugfpv.data as user_gallery_footprint_data'
      footprint_sql_from = <<-"FSQL"
      LEFT JOIN user_gallery_footprint_pagings ugfp ON ugfp.user_id = #{user_id} AND g.id = ugfp.gallery_id AND ugfp.page_num = gepp.page_num AND ugfp.del_flg = 0
      LEFT JOIN user_gallery_footprint_pagevalues ugfpv ON ugfp.user_gallery_footprint_pagevalue_id = ugfpv.id AND ugfpv.del_flg = 0
      FSQL
    end
    pages = "(#{target_pages.join(',')})"
    sql = <<-"SQL"
      SELECT ggp.data as general_pagevalue_data, gip.data as instance_pagevalue_data, gep.data as event_pagevalue_data, gipp.page_num as page_num #{footprint_sql_select}
      FROM galleries g
      LEFT JOIN gallery_general_pagevalue_pagings ggpp ON g.id = ggpp.gallery_id AND ggpp.page_num IN #{pages} AND ggpp.del_flg = 0
      LEFT JOIN gallery_general_pagevalues ggp ON ggpp.gallery_general_pagevalue_id = ggp.id AND ggp.del_flg = 0
      LEFT JOIN gallery_instance_pagevalue_pagings gipp ON g.id = gipp.gallery_id AND gipp.page_num = ggpp.page_num AND gipp.del_flg = 0
      LEFT JOIN gallery_instance_pagevalues gip ON gipp.gallery_instance_pagevalue_id = gip.id AND gip.del_flg = 0
      LEFT JOIN gallery_event_pagevalue_pagings gepp ON g.id = gepp.gallery_id AND gipp.page_num = gepp.page_num AND gepp.del_flg = 0
      LEFT JOIN gallery_event_pagevalues gep ON gepp.gallery_event_pagevalue_id = gep.id AND gep.del_flg = 0
      #{footprint_sql_from}
      WHERE g.access_token = '#{access_token}'
      AND g.del_flg = 0
    SQL
    ret_sql = ActiveRecord::Base.connection.select_all(sql)
    pagevalues = ret_sql.to_hash
    if pagevalues.count == 0
      return true, nil
    else
      gen = {}
      ins = {}
      ent = {}
      fot = {}
      itemids = []
      pagevalues.each do |pagevalue|
        gen[Const::PageValueKey::P_PREFIX + pagevalue['page_num'].to_s] = JSON.parse(pagevalue['general_pagevalue_data'])
        ins[Const::PageValueKey::P_PREFIX + pagevalue['page_num'].to_s] = JSON.parse(pagevalue['instance_pagevalue_data'])
        if load_footprint
          fot[Const::PageValueKey::P_PREFIX + pagevalue['page_num'].to_s] = JSON.parse(pagevalue['user_gallery_footprint_data'])
        end
        epd = JSON.parse(pagevalue['event_pagevalue_data'])
        ent[Const::PageValueKey::P_PREFIX + pagevalue['page_num'].to_s] = epd

        need_load_itemids = PageValueState.extract_need_load_itemids(epd)
        itemids = need_load_itemids - loaded_itemids
      end
      item_js_list = ItemJs.extract_iteminfo(PreloadItem.find(itemids))

      return true, {
          general_pagevalue: gen,
          instance_pagevalue: ins,
          event_pagevalue: ent,
          footprint: fot
      }, item_js_list
    end
  end

  def self.get_list_contents(search_type, show_head, show_limit, tag_ids, date)
    if search_type == Const::Gallery::SearchType::CREATED
      return Gallery.grid_contents_sorted_by_createdate(show_head, show_limit, tag_ids)
    elsif search_type == Const::Gallery::SearchType::VIEW_COUNT
      return Gallery.grid_contents_sorted_by_viewcount(show_head, show_limit, date, tag_ids)
    elsif search_type == Const::Gallery::SearchType::BOOKMARK_COUNT
      return Gallery.grid_contents_sorted_by_bookmarkcount(show_head, show_limit, date, tag_ids)
    end
    return nil
  end

  def self.grid_index(show_head, show_limit, date, tag_ids)
    sql =<<-"SQL"
      (#{grid_contents_sorted_by_createdate_sql(show_head, show_limit)})
      UNION ALL
      (#{grid_contents_sorted_by_viewcount_sql(show_head, show_limit, date)})
      UNION ALL
      (#{grid_contents_sorted_by_bookmarkcount_sql(show_head, show_limit, date, tag_ids)})
    SQL
    contents = ActiveRecord::Base.connection.select_all(sql)
    if contents.present? && contents.count > 0
      return contents.to_hash
    end
    return null
  end

  def self.get_bookmarked_tag(user_id)
    if user_id
      sql =<<-"SQL"
      SELECT gt.category as category
      FROM gallery_bookmarks gb
      INNER JOIN galleries g ON g.id = gb.gallery_id AND g.del_flg = 0
      LEFT JOIN gallery_tag_maps gtm ON g.id = gtm.gallery_id AND gtm.del_flg = 0
      LEFT JOIN gallery_tags gt ON gtm.gallery_tag_id = gt.id AND gt.del_flg = 0
      WHERE gb.user_id = #{user_id}
      AND gb.del_flg = 0
      SQL
      contents = ActiveRecord::Base.connection.select_all(sql)
      if contents.present? && contents.count > 0
        return contents.to_hash.map{|c| c['category']}
      end
    end
    return nil
  end

  def self.grid_contents_select(search_type)
    return <<-"VALUE"
      g.access_token as #{Const::Gallery::Key::GALLERY_ACCESS_TOKEN},
      g.title as #{Const::Gallery::Key::TITLE},
      g.caption as #{Const::Gallery::Key::CAPTION},
      g.thumbnail_img_width as #{Const::Gallery::Key::THUMBNAIL_IMG_WIDTH},
      g.thumbnail_img_height as #{Const::Gallery::Key::THUMBNAIL_IMG_HEIGHT},
      g.screen_width as #{Const::Gallery::Key::SCREEN_SIZE_WIDTH},
      g.screen_height as #{Const::Gallery::Key::SCREEN_SIZE_HEIGHT},
      '#{search_type}' as #{Const::Gallery::Key::SEARCH_TYPE}
    VALUE
  end

  def self.grid_contents_sorted_by_createdate(head, show_limit, tag_ids)
    contents = ActiveRecord::Base.connection.select_all(grid_contents_sorted_by_createdate_sql(head, show_limit, tag_ids))
    if contents.present? && contents.count > 0
      return contents.to_hash
    end
    return null
  end

  def self.grid_contents_sorted_by_createdate_sql(head, show_limit, tag_ids = nil)
    table = nil
    if tag_ids.present? && tag_ids.length > 0
      tags_in = "(#{tag_ids.join(',')})"
      table =<<-"TABLE"
        (
        SELECT g2.*
        FROM galleries g2
        LEFT JOIN gallery_tag_maps as gtm2 ON g2.id = gtm2.gallery_id AND gtm2.del_flg = 0
        LEFT JOIN gallery_tags as gt2 ON gtm2.gallery_tag_id = gt2.id AND gt2.del_flg = 0
        WHERE gt2.id IN #{tags_in}
        AND g2.del_flg = 0
        ORDER BY g.created_at DESC LIMIT #{head}, #{show_limit})"
        )
      TABLE
    else
      table = "(SELECT * FROM galleries ORDER BY created_at DESC LIMIT #{head}, #{show_limit})"
    end

    sql =<<-"SQL"
     SELECT #{grid_contents_select(Const::Gallery::SearchType::CREATED)}
     FROM #{table} g
     LEFT JOIN gallery_tag_maps as gtm ON g.id = gtm.gallery_id AND gtm.del_flg = 0
     LEFT JOIN gallery_tags as gt ON gtm.gallery_tag_id = gt.id AND gt.del_flg = 0
    SQL
    return sql
  end

  def self.grid_contents_sorted_by_viewcount(head, show_limit, date, tag_ids)
    contents = ActiveRecord::Base.connection.select_all(grid_contents_sorted_by_viewcount_sql(head, show_limit, date, tag_ids))
    if contents.present? && contents.count > 0
      return contents.to_hash
    end
    return null
  end

  def self.grid_contents_sorted_by_viewcount_sql(head, show_limit, date, tag_ids = nil)
    where = 'WHERE g.del_flg = 0'
    if date.present?
      where += " AND DATEDIFF(#{date}, gbs.view_day) = 0"
    end
    if tag_ids.present? && tag_ids.length > 0
      tags_in = "(#{tag_ids.join(',')})"
      where += " AND gt.id IN #{tags_in}"
    end
    sql =<<-"SQL"
      SELECT #{grid_contents_select(Const::Gallery::SearchType::VIEW_COUNT)}
      FROM galleries g
      INNER JOIN gallery_view_statistics as gbs ON g.id = gbs.gallery_id AND gbs.del_flg = 0
      LEFT JOIN gallery_tag_maps as gtm ON g.id = gtm.gallery_id AND gtm.del_flg = 0
      LEFT JOIN gallery_tags as gt ON gtm.gallery_tag_id = gt.id AND gt.del_flg = 0
      #{where}
      ORDER BY gbs.count DESC LIMIT #{head}, #{show_limit}
    SQL
    return sql
  end

  def self.grid_contents_sorted_by_bookmarkcount(head, show_limit, date, tag_ids)
    contents = ActiveRecord::Base.connection.select_all(grid_contents_sorted_by_bookmarkcount_sql(head, show_limit, date, tag_ids))
    if contents.present? && contents.count > 0
      return contents.to_hash
    end
    return null
  end

  def self.grid_contents_sorted_by_bookmarkcount_sql(head, show_limit, date, tag_ids = nil)
    where = 'WHERE g.del_flg = 0'
    if date.present?
      where += " AND DATEDIFF(#{date}, gbs.view_day) = 0"
    end
    if tag_ids.present? && tag_ids.length > 0
      tags_in = "(#{tag_ids.join(',')})"
      where += " AND gt.id IN #{tags_in}"
    end
    sql =<<-"SQL"
      SELECT #{grid_contents_select(Const::Gallery::SearchType::BOOKMARK_COUNT)}
      FROM galleries g
      INNER JOIN gallery_bookmark_statistics as gbs ON g.id = gbs.gallery_id AND gbs.del_flg = 0
      LEFT JOIN gallery_tag_maps as gtm ON g.id = gtm.gallery_id AND gtm.del_flg = 0
      LEFT JOIN gallery_tags as gt ON gtm.gallery_tag_id = gt.id AND gt.del_flg = 0
      #{where}
      ORDER BY gbs.count DESC LIMIT #{head}, #{show_limit}
    SQL
    return sql
  end

  def self.grid_contents_user_bookmark(user_id, head, show_limit)
    contents = ActiveRecord::Base.connection.select_all(grid_contents_user_bookmark_sql(user_id, head, show_limit))
    if contents.present? && contents.count > 0
      return contents.to_hash
    end
    return null
  end

  def self.grid_contents_user_bookmark_sql(user_id, head, show_limit)
    sql =<<-"SQL"
      SELECT #{grid_contents_select(Const::Gallery::SearchType::USER_BOOKMARK)}
      FROM galleries g
      INNER JOIN gallery_bookmarks as gb ON g.id = gb.gallery_id AND gb.user_id = #{user_id}
      WHERE g.del_flg = 0
      ORDER BY g.updated_at
      LIMIT #{head}, #{show_limit}
    SQL
    return sql
  end

  def self.send_imagedata(contents)
    contents.each do |content|
      send_data contents[Const::Gallery::Key::THUMBNAIL_IMG], :type => 'image/jpeg', :disposition => 'inline'
    end
  end

  def self.load_instance_pagevalue(gallery_id)
    ipd = null
    gallery_instance_pages = GalleryInstancePagevaluePaging.joins(:gallery, :gallery_instance_pagevalue).where(gallery: {id: gallery_id})
                                 .select('gallery_instance_pagevalue_pagings.*, gallery_instance_pagevalues.data as data')
    if gallery_instance_pages.size > 0
      ipd = {}
      gallery_instance_pages.each do |p|
        key = Const::PageValueKey::P_PREFIX + p.page_num.to_s
        ipd[key] = p.data
      end
    end
    return ipd
  end

  def self.load_event_pagevalue_and_jslist(access_token, loaded_itemids = [])
    item_js_list = []
    epd = null
    # EventPageValue
    gallery_event_pages = GalleryEventPagevaluePaging.joins(:gallery, :gallery_event_pagevalue).where(gallery: {access_token: access_token})
                              .select('gallery_event_pagevalue_pagings.*, gallery_event_pagevalues.data as data')
    if gallery_event_pages.size > 0
      itemids = []
      epd = {}
      gallery_event_pages.each do |p|
        key = Const::PageValueKey::P_PREFIX + p.page_num.to_s
        epd[key] = p.data

        # JSの読み込みが必要なItemIdを調査
        itemids = PageValueState.extract_need_load_itemids(epd[key])
        itemids -= loaded_itemids
      end

      item_js_list = ItemJs.extract_iteminfo(PreloadItem.find(itemids))
    end

    return epd, item_js_list
  end

  def self.load_viewcount_and_bookmarkcount(gallery_id)
    gallery_view_statistic_count = GalleryViewStatistic.where({gallery_id: gallery_id}).group(:gallery_id).sum(:count)
    gallery_bookmark_statistic_count = GalleryBookmarkStatistic.where({gallery_id: gallery_id}).group(:gallery_id).sum(:count)
    return gallery_view_statistic_count, gallery_bookmark_statistic_count
  end

  def self.grid_contents_size_and_style(img_width, img_height)
    r = Random.new.rand(0..15).to_i
    class_name = nil
    style = nil
    # img_wrapper サイズ
    w = 180 - (3 * 2)
    h = 180 - 20 - (3 * 2)
    if r == 0
      class_name = 'grid-item-width2 grid-item-height2'
      w *= 2
      h *= 2
    elsif r == 1 || r == 2
      class_name = 'grid-item-width2'
      w *= 2
    elsif r == 3 || r == 4
      class_name = 'grid-item-height2'
      h *= 2
    else
      class_name = ''
    end

    if img_height / img_width > h / w
      style = 'width:100%;height:auto;'
    else
      style = 'width:auto;height:100%;'
    end

    if img_width / img_height > 1.5 && class_name = 'grid-item-height2'
      class_name, style = grid_size_classname(img_width, img_height)
    elsif img_height / img_width > 1.5 && class_name = 'grid-item-width2'
      class_name, style = grid_size_classname(img_width, img_height)
    end

    return class_name, style

  end

  def self.created_contents(user_id, head = 0, limit = 30)
    sql =<<-"SQL"
      SELECT
        g.access_token as #{Const::Gallery::Key::GALLERY_ACCESS_TOKEN},
        g.title as #{Const::Gallery::Key::TITLE},
        g.caption as #{Const::Gallery::Key::CAPTION},
        g.thumbnail_img_width as #{Const::Gallery::Key::THUMBNAIL_IMG_WIDTH},
        g.thumbnail_img_height as #{Const::Gallery::Key::THUMBNAIL_IMG_HEIGHT},
        g.screen_width as #{Const::Gallery::Key::SCREEN_SIZE_WIDTH},
        g.screen_height as #{Const::Gallery::Key::SCREEN_SIZE_HEIGHT},
        u.name as #{Const::User::Key::NAME},
        u.access_token as #{Const::User::Key::USER_ACCESS_TOKEN},
        group_concat(gt.name separator ',') as #{Const::Gallery::Key::TAGS}
      FROM user_project_maps upm
      INNER JOIN users u ON upm.user_id = u.id
      INNER JOIN project_gallery_maps pgm ON pgm.user_project_map_id = pgm.id
      INNER JOIN galleries g ON g.id = pgm.gallery_id
      INNER JOIN gallery_tag_maps gtm ON gtm.gallery_id = g.id
      INNER JOIN gallery_tags gt ON gtm.gallery_tag_id = gt.id
      WHERE u.id = #{user_id}
      AND u.del_flg = 0 AND pgm.del_flg = 0 AND upm.del_flg = 0 AND g.del_flg = 0
      AND gtm.del_flg = 0 AND gt.del_flg = 0
      GROUP BY g.id
      ORDER BY g.updated_at DESC
      LIMIT #{head}, #{limit}
    SQL
    ret_sql = ActiveRecord::Base.connection.select_all(sql)
    return ret_sql.to_hash
  end

  def self.bookmarks(user_id, head = 0, limit = 30)
    sql =<<-"SQL"
      SELECT
        g.access_token as #{Const::Gallery::Key::GALLERY_ACCESS_TOKEN},
        g.title as #{Const::Gallery::Key::TITLE},
        g.caption as #{Const::Gallery::Key::CAPTION},
        g.thumbnail_img_width as #{Const::Gallery::Key::THUMBNAIL_IMG_WIDTH},
        g.thumbnail_img_height as #{Const::Gallery::Key::THUMBNAIL_IMG_HEIGHT},
        g.screen_width as #{Const::Gallery::Key::SCREEN_SIZE_WIDTH},
        g.screen_height as #{Const::Gallery::Key::SCREEN_SIZE_HEIGHT},
        u.name as #{Const::User::Key::NAME},
        u.access_token as #{Const::User::Key::USER_ACCESS_TOKEN},
        group_concat(gt.name separator ',') as #{Const::Gallery::Key::TAGS}
      FROM gallery_bookmarks gb
      INNER JOIN users u ON gb.user_id = u.id
      INNER JOIN galleries g ON g.id = gb.gallery_id
      WHERE u.id = #{user_id}
      AND u.del_flg = 0 AND gb.del_flg = 0 AND g.del_flg = 0
      AND gtm.del_flg = 0 AND gt.del_flg = 0
      GROUP BY g.id
      ORDER BY gb.updated_at DESC
      LIMIT #{head}, #{limit}
    SQL
    ret_sql = ActiveRecord::Base.connection.select_all(sql)
    return ret_sql.to_hash
  end

  private_class_method :save_tag, :send_imagedata, :load_instance_pagevalue, :load_event_pagevalue_and_jslist, :load_viewcount_and_bookmarkcount
end
