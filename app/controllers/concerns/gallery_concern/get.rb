module GalleryConcern
  module Get
    extend ActiveSupport::Concern

    include RunConcern::Run
    include ItemJsConcern::Get

    def get_gallery_project_pagevalues(upm_id)
      # Pagevalueレコード取得(UserPagevaluesテーブルの最新データ)
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
            up.user_project_map_id = #{upm_id.to_i}
          AND
            up.del_flg = 0
          AND
            up.updated_at = (
              SELECT MAX(up2.updated_at)
              FROM user_pagevalues up2
              WHERE up2.user_project_map_id = #{upm_id.to_i}
              AND up2.del_flg = 0
            )

      SQL
      return ActiveRecord::Base.connection.select_all(sql).to_hash
    end

    def firstload_gallery_contents(user_id, access_token, hostname, page_num = 1)
      sql = <<-"SQL".strip_heredoc
      SELECT
        g.title as #{Const::Gallery::Key::TITLE},
        g.caption as #{Const::Gallery::Key::CAPTION},
        g.screen_width as #{Const::Gallery::Key::SCREEN_SIZE_WIDTH},
        g.screen_height as #{Const::Gallery::Key::SCREEN_SIZE_HEIGHT},
        g.page_max as #{Const::Gallery::Key::PAGE_MAX},
        g.show_guide as #{Const::Gallery::Key::SHOW_GUIDE},
        g.show_page_num as #{Const::Gallery::Key::SHOW_PAGE_NUM},
        g.show_chapter_num as #{Const::Gallery::Key::SHOW_CHAPTER_NUM},
        u.id as #{Const::Gallery::Key::USER_ID},
        u.name as #{Const::Gallery::Key::USER_NAME},
        u.thumbnail_img as #{Const::Gallery::Key::USER_THUMBNAIL_IMG},
        ggp.data as #{Const::Gallery::Key::GENERAL_PAGEVALUE_DATA},
        gip.data as #{Const::Gallery::Key::INSTANCE_PAGEVALUE_DATA},
        gep.data as #{Const::Gallery::Key::EVENT_PAGEVALUE_DATA},
        gbs.count as #{Const::Gallery::Key::BOOKMARK_COUNT},
        gvs.count as #{Const::Gallery::Key::VIEW_COUNT},
        ugf.page_num as #{Const::Gallery::Key::FOOTPRINT_PAGE_NUM},
        gb.id as #{Const::Gallery::Key::BOOKMARK_ID},
        group_concat(DISTINCT gt.id separator ',') as #{Const::Gallery::Key::TAG_ID},
        group_concat(DISTINCT gt.name separator ',') as #{Const::Gallery::Key::TAG_NAME}
      FROM galleries g
      INNER JOIN users u ON g.created_user_id = u.id
      LEFT JOIN gallery_general_pagevalue_pagings ggpp ON g.id = ggpp.gallery_id AND ggpp.page_num = #{page_num.to_i} AND ggpp.del_flg = 0
      LEFT JOIN gallery_general_pagevalues ggp ON ggpp.gallery_general_pagevalue_id = ggp.id AND ggp.del_flg = 0
      LEFT JOIN gallery_instance_pagevalue_pagings gipp ON g.id = gipp.gallery_id AND gipp.page_num = ggpp.page_num AND gipp.del_flg = 0
      LEFT JOIN gallery_instance_pagevalues gip ON gipp.gallery_instance_pagevalue_id = gip.id AND gip.del_flg = 0
      LEFT JOIN gallery_event_pagevalue_pagings gepp ON g.id = gepp.gallery_id AND gipp.page_num = gepp.page_num AND gepp.del_flg = 0
      LEFT JOIN gallery_event_pagevalues gep ON gepp.gallery_event_pagevalue_id = gep.id AND gep.del_flg = 0
      LEFT JOIN gallery_bookmark_statistics gbs ON g.id = gbs.gallery_id AND gbs.del_flg = 0
      LEFT JOIN gallery_view_statistics gvs ON g.id = gvs.gallery_id AND gvs.del_flg = 0
      LEFT JOIN user_gallery_footprints ugf ON ugf.user_id = u.id AND ugf.gallery_id = g.id AND ugf.del_flg = 0
      LEFT JOIN gallery_bookmarks gb ON gb.user_id = #{user_id.to_i} AND g.id = gb.gallery_id AND gb.del_flg = 0
      LEFT JOIN gallery_tag_maps gtm ON g.id = gtm.gallery_id AND gtm.del_flg = 0
      LEFT JOIN gallery_tags gt ON gt.id = gtm.gallery_tag_id AND gt.del_flg = 0
      WHERE g.access_token = #{ActiveRecord::Base.connection.quote(access_token)}
      AND g.del_flg = 0
      GROUP BY g.id
      LIMIT 1
      SQL
      ret_sql = ActiveRecord::Base.connection.select_all(sql)
      ret = ret_sql.to_hash
      if ret.count == 0
        message = I18n.t('message.database.item_state.load.error')
        return nil
      else
        ret = ret.first
        gpd = {}
        gpd[Const::Project::Key::SCREEN_SIZE] = {
            width: ret[Const::Gallery::Key::SCREEN_SIZE_WIDTH],
            height: ret[Const::Gallery::Key::SCREEN_SIZE_HEIGHT]
        }
        gpd[Const::PageValueKey::PAGE_COUNT] = ret[Const::Gallery::Key::PAGE_MAX]
        gpd[Const::PageValueKey::P_PREFIX + page_num.to_s] = JSON.parse(ret[Const::Gallery::Key::GENERAL_PAGEVALUE_DATA])
        ipd = {}
        ipd[Const::PageValueKey::P_PREFIX + page_num.to_s] = JSON.parse(ret[Const::Gallery::Key::INSTANCE_PAGEVALUE_DATA])
        epd = {}
        epd[Const::PageValueKey::P_PREFIX + page_num.to_s] = JSON.parse(ret[Const::Gallery::Key::EVENT_PAGEVALUE_DATA])
        fpd = {}
        if ret[Const::Gallery::Key::FOOTPRINT_PAGE_NUM].present?
          fpd[Const::PageValueKey::PAGE_NUM] = ret[Const::Gallery::Key::FOOTPRINT_PAGE_NUM]
        else
          fpd[Const::PageValueKey::PAGE_NUM] = 1
        end

        # 必要なItemを調査
        class_dist_tokens = extract_need_load_itemclassdisttokens(ret[Const::Gallery::Key::EVENT_PAGEVALUE_DATA])
        item_js_list = get_item_gallery(class_dist_tokens)

        # 閲覧数 & ブックマーク数を取得
        gallery_view_count = ret[Const::Gallery::Key::VIEW_COUNT]
        gallery_bookmark_count = ret[Const::Gallery::Key::BOOKMARK_COUNT]

        pagevalues, creator = setup_run_data(ret[Const::Gallery::Key::USER_ID].to_i, gpd, ipd, epd, fpd, page_num)

        show_options = {}
        show_options[Const::Gallery::Key::SHOW_GUIDE] = ret[Const::Gallery::Key::SHOW_GUIDE]
        show_options[Const::Gallery::Key::SHOW_PAGE_NUM] = ret[Const::Gallery::Key::SHOW_PAGE_NUM]
        show_options[Const::Gallery::Key::SHOW_CHAPTER_NUM] = ret[Const::Gallery::Key::SHOW_CHAPTER_NUM]

        message = I18n.t('message.database.item_state.load.success')
        string_link = gallery_link_string(access_token, hostname, ret[Const::Gallery::Key::TITLE])
        embed_link = gallery_embed_link(gpd, access_token, hostname)
        bookmarked = ret[Const::Gallery::Key::BOOKMARK_ID].present?
        tags = []
        if ret[Const::Gallery::Key::TAG_ID].present?
          tag_names = ret[Const::Gallery::Key::TAG_NAME].split(',')
          ret[Const::Gallery::Key::TAG_ID].split(',').each_with_index do |t, idx|
            tags.push({id: t, name: tag_names[idx]})
          end
        end

        return pagevalues, message, ret[Const::Gallery::Key::TITLE], ret[Const::Gallery::Key::CAPTION], gpd[Const::Project::Key::SCREEN_SIZE], creator, item_js_list, gallery_view_count, gallery_bookmark_count, show_options, string_link, embed_link, bookmarked, tags
      end
    end

    def gallery_link_string(access_token, hostname, title)
      href = "http://#{hostname}/gallery/detail/#{access_token}"
      link = """
    <a href='#{href}'>#{title}</a>
    """.strip
      return link
    end

    def gallery_embed_link(gpd, access_token, hostname)
      src = "http://#{hostname}/gallery/detail/e/#{access_token}"
      size = gpd[Const::Project::Key::SCREEN_SIZE]
      link = """
    <iframe src='#{src}' width='#{size[:width]}' height='#{size[:height]}' frameborder='0' marginwidth='0' marginheight='0' scrolling='no' style='border:1px solid #CCC; border-width:1px; max-width: 100%;'></iframe>
    """.strip
      return link
    end

    def get_gallery_creator_info_by_gallery_id(gallery_id)
      begin
        sql =<<-"SQL"
        SELECT u.id as user_id, u.name as user_name
        FROM users u
        INNER JOIN galleries g ON g.created_user_id = u.id AND g.id = #{gallery_id.to_i}
        SQL
        ret_sql = ActiveRecord::Base.connection.select_all(sql).to_hash
        ret = nil
        if ret_sql.length > 0
          ret = {
              id: ret_sql.first['user_id'],
              name: ret_sql.first['user_name']
          }
        end
        return true, I18n.t('message.database.item_state.save.success'), ret
      rescue => e
        # 失敗
        return false, I18n.t('message.database.item_state.save.error'), nil
      end
    end

    def created_gallery_contents(user_id, head = 0, limit = 30)
      sql =<<-"SQL"
      SELECT
        g.access_token as #{Const::Gallery::Key::GALLERY_ACCESS_TOKEN},
        g.title as #{Const::Gallery::Key::TITLE},
        g.caption as #{Const::Gallery::Key::CAPTION},
        g.thumbnail_url as #{Const::Gallery::Key::THUMBNAIL_URL},
        g.thumbnail_img_width as #{Const::Gallery::Key::THUMBNAIL_IMG_WIDTH},
        g.thumbnail_img_height as #{Const::Gallery::Key::THUMBNAIL_IMG_HEIGHT},
        g.screen_width as #{Const::Gallery::Key::SCREEN_SIZE_WIDTH},
        g.screen_height as #{Const::Gallery::Key::SCREEN_SIZE_HEIGHT},
        u.name as #{Const::User::Key::NAME},
        u.access_token as #{Const::User::Key::USER_ACCESS_TOKEN},
        group_concat(gt.name separator ',') as #{Const::Gallery::Key::TAGS}
      FROM users u
      INNER JOIN galleries g ON g.created_user_id = u.id
      LEFT JOIN gallery_tag_maps gtm ON gtm.gallery_id = g.id AND gtm.del_flg = 0
      LEFT JOIN gallery_tags gt ON gtm.gallery_tag_id = gt.id AND gt.del_flg = 0
      WHERE u.id = #{user_id.to_i}
      AND u.del_flg = 0 AND g.del_flg = 0
      GROUP BY g.id
      ORDER BY g.updated_at DESC
      LIMIT #{head.to_i}, #{limit.to_i}
      SQL
      ret_sql = ActiveRecord::Base.connection.select_all(sql)
      return ret_sql.to_hash
    end

    def gallery_bookmarks(user_id, head = 0, limit = 30)
      sql =<<-"SQL"
      SELECT
        g.access_token as #{Const::Gallery::Key::GALLERY_ACCESS_TOKEN},
        g.title as #{Const::Gallery::Key::TITLE},
        g.caption as #{Const::Gallery::Key::CAPTION},
        g.thumbnail_url as #{Const::Gallery::Key::THUMBNAIL_URL},
        g.thumbnail_img_width as #{Const::Gallery::Key::THUMBNAIL_IMG_WIDTH},
        g.thumbnail_img_height as #{Const::Gallery::Key::THUMBNAIL_IMG_HEIGHT},
        g.screen_width as #{Const::Gallery::Key::SCREEN_SIZE_WIDTH},
        g.screen_height as #{Const::Gallery::Key::SCREEN_SIZE_HEIGHT},
        u.name as #{Const::User::Key::NAME},
        gb.note as #{Const::Gallery::Key::NOTE},
        u.access_token as #{Const::User::Key::USER_ACCESS_TOKEN},
        group_concat(gt.name separator ',') as #{Const::Gallery::Key::TAGS}
      FROM gallery_bookmarks gb
      INNER JOIN users u ON gb.user_id = u.id
      INNER JOIN galleries g ON g.id = gb.gallery_id
      LEFT JOIN gallery_tag_maps gtm ON gtm.gallery_id = g.id AND gtm.del_flg = 0
      LEFT JOIN gallery_tags gt ON gtm.gallery_tag_id = gt.id AND gt.del_flg = 0
      WHERE u.id = #{user_id.to_i}
      AND u.del_flg = 0 AND gb.del_flg = 0 AND g.del_flg = 0
      GROUP BY g.id
      ORDER BY gb.updated_at DESC
      LIMIT #{head.to_i}, #{limit.to_i}
      SQL
      ret_sql = ActiveRecord::Base.connection.select_all(sql)
      return ret_sql.to_hash
    end

    def gallery_paging(user_id, access_token, target_pages, loaded_class_dist_tokens, load_footprint)
      # TODO: 操作履歴は後でMemcachedに変更予定

      footprint_sql_select = ''
      footprint_sql_from = ''
      if load_footprint
        footprint_sql_select = ', ugfpv.data as user_gallery_footprint_data'
        footprint_sql_from = <<-"FSQL"
      LEFT JOIN user_gallery_footprint_pagings ugfp ON ugfp.user_id = #{user_id.to_i} AND g.id = ugfp.gallery_id AND ugfp.page_num = gepp.page_num AND ugfp.del_flg = 0
      LEFT JOIN user_gallery_footprint_pagevalues ugfpv ON ugfp.user_gallery_footprint_pagevalue_id = ugfpv.id AND ugfpv.del_flg = 0
        FSQL
      end
      pages = "(#{target_pages.map{|m| m.to_i}.join(',')})"
      sql = <<-"SQL"
      SELECT ggp.data as general_pagevalue_data, gip.data as instance_pagevalue_data, gep.data as event_pagevalue_data, gipp.page_num as page_num #{footprint_sql_select}
      FROM galleries g
      INNER JOIN users u ON g.created_user_id = u.id
      LEFT JOIN gallery_general_pagevalue_pagings ggpp ON g.id = ggpp.gallery_id AND ggpp.page_num IN #{pages} AND ggpp.del_flg = 0
      LEFT JOIN gallery_general_pagevalues ggp ON ggpp.gallery_general_pagevalue_id = ggp.id AND ggp.del_flg = 0
      LEFT JOIN gallery_instance_pagevalue_pagings gipp ON g.id = gipp.gallery_id AND gipp.page_num = ggpp.page_num AND gipp.del_flg = 0
      LEFT JOIN gallery_instance_pagevalues gip ON gipp.gallery_instance_pagevalue_id = gip.id AND gip.del_flg = 0
      LEFT JOIN gallery_event_pagevalue_pagings gepp ON g.id = gepp.gallery_id AND gipp.page_num = gepp.page_num AND gepp.del_flg = 0
      LEFT JOIN gallery_event_pagevalues gep ON gepp.gallery_event_pagevalue_id = gep.id AND gep.del_flg = 0
      #{footprint_sql_from}
      WHERE g.access_token = #{ActiveRecord::Base.connection.quote(access_token)}
      AND g.del_flg = 0
      SQL
      ret_sql = ActiveRecord::Base.connection.select_all(sql)
      ret = ret_sql.to_hash
      if ret.count == 0
        return true, nil
      else
        gen = {}
        ins = {}
        ent = {}
        fot = {}
        class_dist_tokens = []
        ret.each do |pagevalue|
          gen[Const::PageValueKey::P_PREFIX + pagevalue['page_num'].to_s] = JSON.parse(pagevalue['general_pagevalue_data'])
          ins[Const::PageValueKey::P_PREFIX + pagevalue['page_num'].to_s] = JSON.parse(pagevalue['instance_pagevalue_data'])
          if load_footprint
            if pagevalue['user_gallery_footprint_data'].present?
              fot[Const::PageValueKey::P_PREFIX + pagevalue['page_num'].to_s] = JSON.parse(pagevalue['user_gallery_footprint_data'])
            end
          end
          epd = JSON.parse(pagevalue['event_pagevalue_data'])
          ent[Const::PageValueKey::P_PREFIX + pagevalue['page_num'].to_s] = epd

          need_load_class_dist_tokens = extract_need_load_itemclassdisttokens(epd)
          class_dist_tokens = need_load_class_dist_tokens - loaded_class_dist_tokens
        end
        item_js_list = get_item_gallery(class_dist_tokens)

        return true, {
            general_pagevalue: gen,
            instance_pagevalue: ins,
            event_pagevalue: ent,
            footprint: fot
        }, item_js_list
      end
    end

    def get_gallery_contents_with_tags(user_id, access_token)
      if user_id
        sql =<<-"SQL"
      SELECT
        g.title as #{Const::Gallery::Key::TITLE},
        g.caption as #{Const::Gallery::Key::CAPTION},
        g.screen_width as #{Const::Gallery::Key::SCREEN_SIZE_WIDTH},
        g.screen_height as #{Const::Gallery::Key::SCREEN_SIZE_HEIGHT},
        g.page_max as #{Const::Gallery::Key::PAGE_MAX},
        g.show_guide as #{Const::Gallery::Key::SHOW_GUIDE},
        g.show_page_num as #{Const::Gallery::Key::SHOW_PAGE_NUM},
        g.show_chapter_num as #{Const::Gallery::Key::SHOW_CHAPTER_NUM},
        group_concat(DISTINCT gt.id separator ',') as #{Const::Gallery::Key::TAG_ID},
        group_concat(DISTINCT gt.name separator ',') as #{Const::Gallery::Key::TAG_NAME}
      FROM galleries g
      INNER JOIN users u ON g.created_user_id = u.id
      LEFT JOIN gallery_tag_maps gtm ON g.id = gtm.gallery_id AND gtm.del_flg = 0
      LEFT JOIN gallery_tags gt ON gtm.gallery_tag_id = gt.id AND gt.del_flg = 0
      WHERE g.access_token = #{ActiveRecord::Base.connection.quote(access_token)} AND g.created_user_id = #{user_id.to_i}
      AND g.del_flg = 0
      LIMIT 1
        SQL
        return ActiveRecord::Base.connection.select_all(sql)
      end
      return nil
    end

    def load_gallery_viewcount_and_bookmarkcount(gallery_id)
      gallery_view_statistic_count = GalleryViewStatistic.where(gallery_id: gallery_id, del_flg: false).group(:gallery_id).sum(:count)
      gallery_bookmark_statistic_count = GalleryBookmarkStatistic.where(gallery_id: gallery_id, del_flg: false).group(:gallery_id).sum(:count)
      return gallery_view_statistic_count, gallery_bookmark_statistic_count
    end

    def uploaded_gallery_list(user_id, project_id)
      sql =<<-"SQL"
      SELECT g.title as title, g.updated_at as updated_at, g.access_token as gallery_access_token
      FROM user_project_maps upm
      INNER JOIN project_gallery_maps pgm ON upm.id = pgm.user_project_map_id AND upm.del_flg = 0 AND pgm.del_flg = 0
      INNER JOIN projects p ON upm.project_id = p.id AND p.del_flg = 0
      INNER JOIN galleries g ON g.id = pgm.gallery_id AND g.del_flg = 0
      WHERE
        upm.user_id = #{user_id.to_i}
      AND
        upm.project_id = #{project_id.to_i}
      SQL
      ret_sql = ActiveRecord::Base.connection.select_all(sql)
      return ret_sql.to_hash
    end


    def get_popular_gallery_tags
      limit = 50
      take_num = 3

      ordered = self.order('weight DESC').limit(limit)
      get_row = []
      # ランダムに取得
      while get_row.length <= take_num
        random = Random.new
        r = random.rand(0..(limit - 1))
        unless get_row.include?(r)
          get_row << r
        end
      end
      tags = ordered.map do |o|
        if get_row.include?(o.id)
          return o.name
        end
      end

      return tags
    end

    def get_recommend_gallery_tags(got_popular_tags, recommend_source_word)
      if recommend_source_word.blank? || recommend_source_word.length == 0
        return []
      end

      # はてなキーワードでカテゴリを調査
      client = XMLRPC::Client.new2("http://d.hatena.ne.jp/xmlrpc")
      result = client.call("hatena.setKeywordLink", {
          body: recommend_source_word,
          mode: 'lite',
          score: 10
      })
      category = result['wordlist'].first['cname']
      if category.present?
        limit = 30
        take_num = 3

        ordered = self.find_by(category: category, del_flg: false).order('weight DESC').limit(limit)
        get_row = []
        # ランダムに取得
        while get_row.length <= take_num
          random = Random.new
          r = random.rand(0..(limit - 1))
          if !get_row.include?(r) && !got_popular_tags.include?(r)
            get_row << r
          end
        end
        tags = ordered.map do |o|
          if get_row.include?(o.id)
            return o.name
          end
        end

        return tags
      end

      return []
    end


  end
end
