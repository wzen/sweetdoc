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
require 'item/item_image'
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
  belongs_to :user, foreign_key: :created_user_id

  mount_uploader :thumbnail_img, GalleryThumbnailImageUploader
  validates :thumbnail_img,
            file_size: {
                maximum: (Const::THUMBNAIL_FILESIZE_MAX_KB * 0.001).megabytes.to_i
            }

  def self.save_state(
    user_id,
    project_id,
    tags,
    title,
    caption,
    thumbnail_img,
    thumbnail_width,
    thumbnail_height,
    page_max,
    show_guide,
    show_page_num,
    show_chapter_num,
    screen_size,
    upload_overwrite_gallery_token
  )
    begin
      ActiveRecord::Base.transaction do
        if upload_overwrite_gallery_token.present? &&
            (g = Gallery.find_by(access_token: upload_overwrite_gallery_token)).present?
          # 更新
          # ProjectGalelryMap存在チェック
          upm = UserProjectMap.find_by(user_id: user_id, project_id: project_id, del_flg: false)
          pgm = ProjectGalleryMap.new({user_project_map_id: upm.id, gallery_id: g.id})
          if pgm.blank?
            # エラー
            return false, I18n.t('message.database.item_state.save.error'), nil
          end
          g.update!({
                       title: title,
                       caption: caption,
                       thumbnail_img: thumbnail_img,
                       thumbnail_img_width: thumbnail_width,
                       thumbnail_img_height: thumbnail_height,
                       page_max: page_max,
                       screen_width: screen_size.present? ?  screen_size['width'].to_i : nil,
                       screen_height: screen_size.present? ?  screen_size['height'].to_i : nil,
                       show_guide: show_guide,
                       show_page_num: show_page_num,
                       show_chapter_num: show_chapter_num,
                       created_user_id: user_id
                   })
          if thumbnail_img.present?
            # サムネイル画像のURL設定
            g.update!({thumbnail_url: g.thumbnail_img.url})
          else
            # サムネイルを削除
            g.remove_thumbnail_img!
            g.thumbnail_url = nil
            g.thumbnail_img_width = nil
            g.thumbnail_img_height = nil
            g.save!
          end
          gallery_id = g.id
          # Pagevalue更新
          _save_gallery_pagevalue(_get_project_pagevalues(upm.id), gallery_id)
          # Tag レコード追加
          _save_tag(tags, gallery_id)
        else
          # 新規作成
          # Gallery レコード追加
          g = self.new({
                           access_token: SecureRandom.uuid,
                           title: title,
                           caption: caption,
                           thumbnail_img: thumbnail_img,
                           thumbnail_img_width: thumbnail_width,
                           thumbnail_img_height: thumbnail_height,
                           page_max: page_max,
                           screen_width: screen_size.present? ?  screen_size['width'].to_i : nil,
                           screen_height: screen_size.present? ?  screen_size['height'].to_i : nil,
                           show_guide: show_guide,
                           show_page_num: show_page_num,
                           show_chapter_num: show_chapter_num,
                           created_user_id: user_id
                       })
          g.save!
          if thumbnail_img.present?
            # サムネイル画像を絶対パスURLに置き換え
            g.update!({thumbnail_url: g.thumbnail_img.url})
          end
          gallery_id = g.id
          # UserProjectMap取得
          upm = UserProjectMap.find_by(user_id: user_id, project_id: project_id, del_flg: false)
          # ProjectGalelryMap追加
          pgm = ProjectGalleryMap.new({user_project_map_id: upm.id, gallery_id: g.id})
          pgm.save!
          # Pagevalue追加
          _save_gallery_pagevalue(_get_project_pagevalues(upm.id), gallery_id)
          # Tag レコード追加
          _save_tag(tags, gallery_id)
          # Image GalleryIdカラムにID追加
          _update_item_images_column(upm.id, gallery_id)
        end
        return true, I18n.t('message.database.item_state.save.success'), g.access_token
      end
    rescue => e
      # 更新失敗
      return false, I18n.t('message.database.item_state.save.error'), nil
    end
  end

  def self._get_project_pagevalues(upm_id)
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
            up.user_project_map_id = #{upm_id}
          AND
            up.del_flg = 0
          AND
            up.updated_at = (
              SELECT MAX(up2.updated_at)
              FROM user_pagevalues up2
              WHERE up2.user_project_map_id = #{upm_id}
              AND up2.del_flg = 0
            )

    SQL
    return ActiveRecord::Base.connection.select_all(sql).to_hash
  end

  def self._save_gallery_pagevalue(pagevalues, gallery_id)
    pagevalues.each do |pagevalue|
      page_num = pagevalue['page_num']
      g_pagevalue_data = pagevalue['g_pagevalue_data']
      if g_pagevalue_data.present?
        gpp = GalleryGeneralPagevaluePaging.find_by(gallery_id: gallery_id, page_num: page_num)
        if gpp.present? && (gp = GalleryGeneralPagevalue.find_by(gpp.gallery_general_pagevalue_id)).present?
          # update
          gp.data = g_pagevalue_data
          gp.save!
        else
          # insert
          gp = GalleryGeneralPagevalue.new({data: g_pagevalue_data})
          gp.save!
          gpp = GalleryGeneralPagevaluePaging.new({
                                                      gallery_id: gallery_id,
                                                      page_num: page_num,
                                                      gallery_general_pagevalue_id: gp.id
                                                  })
          gpp.save!
        end
      end

      i_pagevalue_data = pagevalue['i_pagevalue_data']
      if i_pagevalue_data.present?
        ipp = GalleryInstancePagevaluePaging.find_by(gallery_id: gallery_id, page_num: page_num)
        if ipp.present? && (ip = GalleryInstancePagevalue.find(ipp.gallery_instance_pagevalue_id)).present?
          # update
          ip.data = i_pagevalue_data
          ip.save!
        else
          # insert
          ip = GalleryInstancePagevalue.new({data: i_pagevalue_data})
          ip.save!
          ipp = GalleryInstancePagevaluePaging.new({
                                                       gallery_id: gallery_id,
                                                       page_num: page_num,
                                                       gallery_instance_pagevalue_id: ip.id
                                                   })
          ipp.save!
        end
      end

      e_pagevalue_data = pagevalue['e_pagevalue_data']
      if e_pagevalue_data.present?
        epp = GalleryEventPagevaluePaging.find_by(gallery_id: gallery_id, page_num: page_num)
        if epp.present? && (ep = GalleryEventPagevalue.find(epp.gallery_event_pagevalue_id)).present?
          # update
          ep.data = e_pagevalue_data
          ep.save!
        else
          # insert
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
    end

    # ページ数を減らしてアップロードした場合のレコードが余りを削除
    after_page_max = pagevalues.count
    before_page_max = GalleryGeneralPagevaluePaging.where(gallery_id: gallery_id).count
    if before_page_max > after_page_max
      gp = GalleryGeneralPagevaluePaging.where('gallery_id = ? AND page_num > ?', gallery_id, after_page_max)
      if gp.present?
        gp..update_all(del_flg:true)
        GalleryGeneralPagevalue.where(id: gp.pluck(:gallery_general_pagevalue_id)).update_all(del_flg:true)
      end
      ip = GalleryInstancePagevaluePaging.where('gallery_id = ? AND page_num > ?', gallery_id, after_page_max)
      if ip.present?
        ip..update_all(del_flg:true)
        GalleryInstancePagevalue.where(id: ip.pluck(:gallery_instance_pagevalue_id)).update_all(del_flg:true)
      end
      ep = GalleryEventPagevaluePaging.where('gallery_id = ? AND page_num > ?', gallery_id, after_page_max)
      if ep.present?
        ep..update_all(del_flg:true)
        GalleryEventPagevalue.where(id: ep.pluck(:gallery_event_pagevalue_id)).update_all(del_flg:true)
      end
    end
  end

  def self.add_view_statistic_count(access_token, date)
    begin
      g = self.find_by({access_token: access_token, del_flg: false})
      gvs = GalleryViewStatistic.where(gallery_id: g.id, view_day: date, del_flg: false).first
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
      return true, I18n.t('message.database.item_state.save.success')
    rescue => e
      # 更新失敗
      return false, I18n.t('message.database.item_state.save.error')
    end
  end

  def self.add_bookmark(user_id, gallery_access_token, note, date)
    begin
      ActiveRecord::Base.transaction do
        update_statistic = false
        g = self.find_by({access_token: gallery_access_token, del_flg: false})
        gallery_id = g.id
        gb = GalleryBookmark.where(gallery_id: gallery_id, user_id: user_id)
        if gb.blank?
          # ブックマークが存在しない場合作成
          gb = GalleryBookmark.new({
                                       gallery_id: gallery_id,
                                       user_id: user_id,
                                       note: note
                                   })
          gb.save!
          update_statistic = true
        elsif gb.first.del_flg
          # ブックマーク有りでdel_flgが立ってる場合は戻す
          gb.update_all(del_flg: false)
          update_statistic = true
        end

        if update_statistic
          # 統計情報更新
          gbs = GalleryBookmarkStatistic.find_by(gallery_id: gallery_id, view_day: date, del_flg: false)
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
      return true, I18n.t('message.database.item_state.save.success')
    rescue => e
      # 更新失敗
      return false, I18n.t('message.database.item_state.save.error')
    end
  end

  def self.remove_bookmark(user_id, gallery_access_token, date)
    begin
      ActiveRecord::Base.transaction do
        g = self.find_by({access_token: gallery_access_token, del_flg: false})
        if g.present?
          # del_flgを立てる
          gb = GalleryBookmark.find_by(user_id: user_id, gallery_id: g.id)
          if gb.present?
            gb.update!(del_flg: true)
            # 統計情報更新
            gbs = GalleryBookmarkStatistic.find_by(gallery_id: g.id, view_day: date, del_flg: false)
            if gbs.present? && gbs.count > 0
              gbs.count -= 1
              gbs.save!
            end
          end
        end
      end
      return true, I18n.t('message.database.item_state.save.success')
    rescue => e
      # 更新失敗
      return false, I18n.t('message.database.item_state.save.error')
    end
  end

  def self.update_last_state(user_id, tags, i_page_values, e_page_values)
    begin
      if i_page_values != 'null' && e_page_values != 'null'

        ActiveRecord::Base.transaction do
          # Instance 最新データ取得
          last_i_page_values = GalleryInstancePagevaluePaging.joins(:gallery).where(gallery: {user_id: user_id, del_flg: false})

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
          last_e_page_values = GalleryEventPagevaluePaging.joins(:gallery).where(gallery: {user_id: user_id, del_flg: false})

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
          _save_tag(tags, gallery_id)

        end
      end

      return true, I18n.t('message.database.item_state.save.success')
    rescue => e
      # 更新失敗
      return false, I18n.t('message.database.item_state.save.error')
    end
  end

  # タグ名のレコードを新規作成
  def self._save_tag(tags, gallery_id)
    begin
      if tags != 'null' && tags.length > 0
        # タグ数がMAX以上のものは削除
        tags = tags.take(Const::Gallery::TAG_MAX)

        # タグテーブル処理
        tag_ids = []
        tags.each do |tag|
          t = GalleryTag.find_by(name: tag, del_flg: false)
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

  def self.firstload_contents(user_id, access_token, hostname, page_num = 1)
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
      LEFT JOIN gallery_general_pagevalue_pagings ggpp ON g.id = ggpp.gallery_id AND ggpp.page_num = #{page_num} AND ggpp.del_flg = 0
      LEFT JOIN gallery_general_pagevalues ggp ON ggpp.gallery_general_pagevalue_id = ggp.id AND ggp.del_flg = 0
      LEFT JOIN gallery_instance_pagevalue_pagings gipp ON g.id = gipp.gallery_id AND gipp.page_num = ggpp.page_num AND gipp.del_flg = 0
      LEFT JOIN gallery_instance_pagevalues gip ON gipp.gallery_instance_pagevalue_id = gip.id AND gip.del_flg = 0
      LEFT JOIN gallery_event_pagevalue_pagings gepp ON g.id = gepp.gallery_id AND gipp.page_num = gepp.page_num AND gepp.del_flg = 0
      LEFT JOIN gallery_event_pagevalues gep ON gepp.gallery_event_pagevalue_id = gep.id AND gep.del_flg = 0
      LEFT JOIN gallery_bookmark_statistics gbs ON g.id = gbs.gallery_id AND gbs.del_flg = 0
      LEFT JOIN gallery_view_statistics gvs ON g.id = gvs.gallery_id AND gvs.del_flg = 0
      LEFT JOIN user_gallery_footprints ugf ON ugf.user_id = u.id AND ugf.gallery_id = g.id AND ugf.del_flg = 0
      LEFT JOIN gallery_bookmarks gb ON gb.user_id = #{user_id} AND g.id = gb.gallery_id AND gb.del_flg = 0
      LEFT JOIN gallery_tag_maps gtm ON g.id = gtm.gallery_id AND gtm.del_flg = 0
      LEFT JOIN gallery_tags gt ON gt.id = gtm.gallery_tag_id AND gt.del_flg = 0
      WHERE g.access_token = '#{access_token}'
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
      class_dist_tokens = PageValueState.extract_need_load_itemclassdisttokens(ret[Const::Gallery::Key::EVENT_PAGEVALUE_DATA])
      item_js_list = ItemJs.get_item_gallery(class_dist_tokens)

      # 閲覧数 & ブックマーク数を取得
      gallery_view_count = ret[Const::Gallery::Key::VIEW_COUNT]
      gallery_bookmark_count = ret[Const::Gallery::Key::BOOKMARK_COUNT]

      pagevalues, creator = Run.setup_data(ret[Const::Gallery::Key::USER_ID].to_i, gpd, ipd, epd, fpd, page_num)

      show_options = {}
      show_options[Const::Gallery::Key::SHOW_GUIDE] = ret[Const::Gallery::Key::SHOW_GUIDE]
      show_options[Const::Gallery::Key::SHOW_PAGE_NUM] = ret[Const::Gallery::Key::SHOW_PAGE_NUM]
      show_options[Const::Gallery::Key::SHOW_CHAPTER_NUM] = ret[Const::Gallery::Key::SHOW_CHAPTER_NUM]

      message = I18n.t('message.database.item_state.load.success')
      string_link = self.string_link(access_token, hostname, ret[Const::Gallery::Key::TITLE])
      embed_link = self.embed_link(gpd, access_token, hostname)
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

  def self.paging(user_id, access_token, target_pages, loaded_class_dist_tokens, load_footprint)
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
      INNER JOIN users u ON g.created_user_id = u.id
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

        need_load_class_dist_tokens = PageValueState.extract_need_load_itemclassdisttokens(epd)
        class_dist_tokens = need_load_class_dist_tokens - loaded_class_dist_tokens
      end
      item_js_list = ItemJs.get_item_gallery(class_dist_tokens)

      return true, {
          general_pagevalue: gen,
          instance_pagevalue: ins,
          event_pagevalue: ent,
          footprint: fot
      }, item_js_list
    end
  end

  def self.get_contents_with_tags(user_id, access_token)
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
      WHERE g.access_token = '#{access_token}' AND g.created_user_id = #{user_id}
      AND g.del_flg = 0
      LIMIT 1
      SQL
      return ActiveRecord::Base.connection.select_all(sql)
    end
    return nil
  end

  def self._load_viewcount_and_bookmarkcount(gallery_id)
    gallery_view_statistic_count = GalleryViewStatistic.where(gallery_id: gallery_id, del_flg: false).group(:gallery_id).sum(:count)
    gallery_bookmark_statistic_count = GalleryBookmarkStatistic.where(gallery_id: gallery_id, del_flg: false).group(:gallery_id).sum(:count)
    return gallery_view_statistic_count, gallery_bookmark_statistic_count
  end

  def self.created_contents_list(user_id, head = 0, limit = 30)
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
      FROM users u
      INNER JOIN galleries g ON g.created_user_id = u.id
      LEFT JOIN gallery_tag_maps gtm ON gtm.gallery_id = g.id AND gtm.del_flg = 0
      LEFT JOIN gallery_tags gt ON gtm.gallery_tag_id = gt.id AND gt.del_flg = 0
      WHERE u.id = #{user_id}
      AND u.del_flg = 0 AND g.del_flg = 0
      GROUP BY g.id
      ORDER BY g.updated_at DESC
      LIMIT #{head}, #{limit}
    SQL
    ret_sql = ActiveRecord::Base.connection.select_all(sql)
    return ret_sql.to_hash
  end

  def self.remove_contents(user_id, gallery_access_token)
    begin
      ActiveRecord::Base.transaction do
        g = Gallery.find_by(access_token: gallery_access_token, created_user_id: user_id)
        if g.present?
          g.del_flg = true
          g.save!
          GalleryBookmarkStatistic.where(gallery_id: g.id).update_all(del_flg: true)
          GalleryBookmark.where(gallery_id: g.id).update_all(del_flg: true)
          gepp = GalleryEventPagevaluePaging.where(gallery_id: g.id)
          if gepp.present?
            GalleryEventPagevalue.where(id: gepp.pluck(:gallery_event_pagevalue_id)).update_all(del_flg: true)
            gepp.update_all(del_flg: true)
          end
          gipp = GalleryInstancePagevaluePaging.where(gallery_id: g.id)
          if gipp.present?
            GalleryInstancePagevalue.where(id: gipp.pluck(:gallery_instance_pagevalue_id)).update_all(del_flg: true)
            gipp.update_all(del_flg: true)
          end
          ggpp = GalleryGeneralPagevaluePaging.where(gallery_id: g.id)
          if ggpp.present?
            GalleryGeneralPagevalue.where(id: ggpp.pluck(:gallery_general_pagevalue_id)).update_all(del_flg: true)
            ggpp.update_all(del_flg: true)
          end
          gtm = GalleryTagMap.where(gallery_id: g.id)
          if gtm.present?
            GalleryTag.where(id: gtm.pluck(:gallery_tag_id)).update_all(del_flg: true)
            gtm.update_all(del_flg: true)
          end
          GalleryViewStatistic.where(gallery_id: g.id).update_all(del_flg: true)
          ProjectGalleryMap.where(gallery_id: g.id).update_all(del_flg: true)
          ItemImage.remove_gallery_img(user_id, g.id)
        end
        return true, I18n.t('message.database.item_state.save.success')
      end
    rescue => e
      # 更新失敗
      return false, I18n.t('message.database.item_state.save.error')
    end
  end

  def self.bookmarks_list(user_id, head = 0, limit = 30)
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
        gb.note as #{Const::Gallery::Key::NOTE},
        u.access_token as #{Const::User::Key::USER_ACCESS_TOKEN},
        group_concat(gt.name separator ',') as #{Const::Gallery::Key::TAGS}
      FROM gallery_bookmarks gb
      INNER JOIN users u ON gb.user_id = u.id
      INNER JOIN galleries g ON g.id = gb.gallery_id
      LEFT JOIN gallery_tag_maps gtm ON gtm.gallery_id = g.id AND gtm.del_flg = 0
      LEFT JOIN gallery_tags gt ON gtm.gallery_tag_id = gt.id AND gt.del_flg = 0
      WHERE u.id = #{user_id}
      AND u.del_flg = 0 AND gb.del_flg = 0 AND g.del_flg = 0
      GROUP BY g.id
      ORDER BY gb.updated_at DESC
      LIMIT #{head}, #{limit}
    SQL
    ret_sql = ActiveRecord::Base.connection.select_all(sql)
    return ret_sql.to_hash
  end

  def self.string_link(access_token, hostname, title)
    href = "http://#{hostname}/gallery/detail/#{access_token}"
    link = """
    <a href='#{href}'>#{title}</a>
    """.strip
    return link
  end

  def self.embed_link(gpd, access_token, hostname)
    src = "http://#{hostname}/gallery/detail/e/#{access_token}"
    size = gpd[Const::Project::Key::SCREEN_SIZE]
    link = """
    <iframe src='#{src}' width='#{size[:width]}' height='#{size[:height]}' frameborder='0' marginwidth='0' marginheight='0' scrolling='no' style='border:1px solid #CCC; border-width:1px; max-width: 100%;'></iframe>
    """.strip
    return link
  end

  def self._update_item_images_column(user_project_map_id, gallery_id)
    ItemImage.where(user_project_map_id: user_project_map_id, del_flg: false).update_all(gallery_id: gallery_id)
  end

  def self.uploaded_gallery_list(user_id, project_id)
    sql =<<-"SQL"
      SELECT g.title as title, g.updated_at as updated_at, g.access_token as gallery_access_token
      FROM user_project_maps upm
      INNER JOIN project_gallery_maps pgm ON upm.id = pgm.user_project_map_id AND upm.del_flg = 0 AND pgm.del_flg = 0
      INNER JOIN projects p ON upm.project_id = p.id AND p.del_flg = 0
      INNER JOIN galleries g ON g.id = pgm.gallery_id AND g.del_flg = 0
      WHERE
        upm.user_id = #{user_id}
      AND
        upm.project_id = #{project_id}
    SQL
    ret_sql = ActiveRecord::Base.connection.select_all(sql)
    return ret_sql.to_hash
  end

  def self.get_creator_info_by_gallery_id(gallery_id)
    begin
      sql =<<-"SQL"
        SELECT u.id as user_id, u.name as user_name
        FROM users u
        INNER JOIN galleries g ON g.created_user_id = u.id AND g.id = #{gallery_id}
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

  private_class_method :_save_tag, :_load_viewcount_and_bookmarkcount, :_update_item_images_column, :_get_project_pagevalues, :_save_gallery_pagevalue
end
