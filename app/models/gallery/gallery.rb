require 'xmlrpc/client'

class Gallery < ActiveRecord::Base
  belongs_to :user
  has_many :gallery_instance_pagevalue_pagings
  has_many :gallery_event_pagevalue_pagings
  has_many :gallery_tag_maps
  has_many :gallery_bookmarks
  has_many :gallery_view_statistics
  has_many :gallery_bookmark_statistics

  def self.save_state(user_id, tags, title, caption, thumbnail_img, i_page_values, e_page_values)
    begin
      if i_page_values != 'null' && e_page_values != 'null'

        ActiveRecord::Base.transaction do
          # Gallery レコード追加
          g = self.new({
                           user_id: user_id,
                           title: title,
                           caption: caption,
                           thumbnail_img: thumbnail_img
                       })
          g.save!
          gallery_id = g.id

          # Instance レコード追加
          i_page_values.each do |k, v|
            page_num = v['pageNum']
            pagevalue = v['pagevalue']

            ip = GalleryInstancePagevalue.new({data: pagevalue})
            ip.save!
            ipp = GalleryInstancePagevaluePaging.new({
                                                  gallery_id: gallery_id,
                                                  page_num: page_num,
                                                  instance_pagevalue_id: ip.id
                                              })
            ipp.save!
          end

          # Event レコード追加
          e_page_values.each do |k, v|
            page_num = v['pageNum']
            pagevalue = v['pagevalue']

            ep = GalleryEventPagevalue.new({data: pagevalue})
            ep.save!
            epp = GalleryEventPagevaluePaging.new({
                                               gallery_id: gallery_id,
                                               page_num: page_num,
                                               event_pagevalue_id: ep.id
                                           })
            epp.save!
          end

          # Tag レコード追加
          save_tag(tags, gallery_id)

        end
      end

      return I18n.t('message.database.item_state.save.success')
    rescue => e
      # 更新失敗
      return I18n.t('message.database.item_state.save.error')
    end
  end

  def self.add_view_statistic_count(gallery_id, date)
    begin
        gvs = GalleryViewStatistic.where({gallery_id: gallery_id, view_day: date})
        if gvs == nil
          # 新規作成
          gvs = GalleryViewStatistic.new({
                                             gallery_id: gallery_id,
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

  def self.add_bookmark(user_id, gallery_id, note, date)
    begin
      ActiveRecord::Base.transaction do
        gb = GalleryBookmark.where({gallery_id: gallery_id, user_id: user_id})
        # 既にブックマークが存在する場合は処理なし
        if gb == nil
          gb = GalleryBookmark.new({
                                       gallery_id: gallery_id,
                                       user_id: user_id,
                                       note: note
                                   })
          gb.save!

          gbs = GalleryBookmarkStatistic.where({gallery_id: gallery_id, view_day: date})
          if gbs == nil
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
            if p == nil
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
              if ip != nil
                ip.data = pagevalue
              end
              ip.save!

            end
          end

          # Instance 不要なレコードの削除フラグを立てる
          extras = last_i_page_values.map{|m| m.page_num.to_i > i_page_values.length}
          extras.each do |extra|
            ip = GalleryInstancePagevalue.find(extra.gallery_instance_pagevalue_id.to_i)
            if ip != nil
              if ip.retain <= 1
                ip.del_flg = true
              end
              ip.retain -= 1
              ip.save!
            end
            ipp = GalleryInstancePagevaluePaging.find(extra.id.to_i)
            if ipp != nil
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
            if p == nil
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
              if ep != nil
                ep.data = pagevalue
              end
              ep.save!

            end
          end

          # Event 不要なレコードの削除フラグを立てる
          extras = last_e_page_values.map{|m| m.page_num.to_i > e_page_values.length}
          extras.each do |extra|
            ep = GalleryEventPagevalue.find(extra.gallery_event_pagevalue_id.to_i)
            if ep != nil
              if ep.retain <= 1
                ep.del_flg = true
              end
              ep.retain -= 1
              ep.save!
            end
            epp = GalleryEventPagevaluePaging.find(extra.id.to_i)
            if epp != nil
              epp.del_flg = true
              epp.save!
            end
          end

          # Tag レコード追加
          save_tag(tags, gallery_id)

        end
      end

      return I18n.t('message.database.item_state.save.success')
    rescue => e
      # 更新失敗
      return I18n.t('message.database.item_state.save.error')
    end
  end

  # タグ名のレコードを新規作成
  def self.save_tag(tags, gallery_id)
    begin
      if tags != nil && tags.length > 0
        # タグ数がMAX以上のものは削除
        tags = tags.take(Const::Gallery::TAG_MAX)

        # タグテーブル処理
        tag_ids = []
        tags.each do |tag|
          tag = GalleryTag.find_by_name(tag).first
          if tag == nil
            # タグを新規作成
            tag = GalleryTag.new({
                                     name: tag
                                 })
            tag.save!
            tag_ids << tag.id

          else
            # タグの重み付けを加算
            tag.weight += 1
            tag.save!
            tag_ids << tag.id
          end
        end

        # 存在しているデータが有る場合削除
        GalleryTagMap.destroy(gallery_id: gallery_id)

        # タグマップテーブル作成
        tag_ids.each do |tag_id|
          # Insert
          map = GalleryTagMap.new({
                                      gallery_id: gallery_id,
                                      gallery_tag_id: tag_id
                                  })
        end

        # タグカテゴリ設定
        GalleryTag.save_tag_category(tags)
      end

    rescue => e
      raise e
    end
  end

  def self.load_contents_detail(gallery_id)
    gallery = self.where({id: gallery_id, del_flg: false})
    if gallery == nil
      message = I18n.t('message.database.item_state.load.error')
      return nil
    else
      message = I18n.t('message.database.item_state.load.success')

      # PageValue
      ipd = load_instance_pagevalue(gallery_id)
      epd, item_js_list = load_event_pagevalue_and_jslist(gallery_id)

      # 閲覧数 & ブックマーク数を取得
      gallery_view_count, gallery_bookmark_count  = load_viewcount_and_bookmarkcount(gallery_id)

      contents_detail = {}
      contents_detail[Const::Gallery::Key::MESSAGE] = message
      contents_detail[Const::Gallery::Key::TITLE] = gallery.title
      contents_detail[Const::Gallery::Key::CAPTION] = gallery.caption
      contents_detail[Const::Gallery::Key::ITEM_JS_LIST] = item_js_list
      contents_detail[Const::Gallery::Key::INSTANCE_PAGE_VALUE] = ipd
      contents_detail[Const::Gallery::Key::EVENT_PAGE_VALUE] = epd
      contents_detail[Const::Gallery::Key::VIEW_COUNT] = gallery_view_count
      contents_detail[Const::Gallery::Key::BOOKMARK_COUNT] = gallery_bookmark_count
      return contents_detail
    end
  end

  def self.load_state(gallery_id, user_id)
    gallery = self.where({id: gallery_id, del_flg: false})
    if gallery == nil
      message = I18n.t('message.database.item_state.load.error')
      return nil
    else
      # ユーザIDのチェック
      if user_id != nil && gallery.user_id != user_id
        message = I18n.t('message.database.item_state.load.error')
        return nil
      end

      message = I18n.t('message.database.item_state.load.success')

      # PageValue
      ipd = load_instance_pagevalue(gallery_id)
      epd, item_js_list = load_event_pagevalue_and_jslist(gallery_id)

      contents_detail = {}
      contents_detail[Const::Gallery::Key::MESSAGE] = message
      contents_detail[Const::Gallery::Key::TITLE] = gallery.title
      contents_detail[Const::Gallery::Key::ITEM_JS_LIST] = item_js_list
      contents_detail[Const::Gallery::Key::INSTANCE_PAGE_VALUE] = ipd
      contents_detail[Const::Gallery::Key::EVENT_PAGE_VALUE] = epd
      return contents_detail
    end
  end

  def self.grid_contents_sorted_by_createdate(head, show_limit, tag_id)
    table = "(SELECT * FROM galleries ORDER BY created_at DESC LIMIT #{head}, #{show_limit})"
    if tag_id != nil
      table = "(SELECT g.* FROM galleries g INNER JOIN gallery_tag_maps as gtm ON g.id = gtm.gallery_id INNER JOIN gallery_tags as gt ON gtm.gallery_tag_id = gt.id WHERE gt.id = #{tag_id} ORDER BY g.created_at DESC LIMIT #{head}, #{show_limit})"
    end

    sql = "SELECT * FROM #{table} AS g INNER JOIN gallery_tag_maps as gtm ON g.id = gtm.gallery_id INNER JOIN gallery_tags as gt ON gtm.gallery_tag_id = gt.id"
    contents = ActiveRecord::Base.connection.select_all(sql)
    if contents != nil
      return contents.to_hash
    end
    return null
  end

  def self.grid_contents_sorted_by_viewcount(head, show_limit, date, tag_id)
    cond = ''
    if date != nil || tag_id != nil
      if date != nil
        cond = "DATEDIFF(#{date}, gbs.view_day) == 0"
      end
      if tag_id != nil
        if cond.length > 0
          cond += " AND gt.id = #{tag_id}"
        else
          cond = "gt.id = #{tag_id}"
        end
      end
      cond = "WHERE #{cond}"
    end
    where = "#{cond} ORDER BY gbs.count DESC LIMIT #{head}, #{show_limit}"
    if tag_id != nil
      where = "WHERE DATEDIFF(#{date}, gbs.view_day) == 0 AND gt.id = #{tag_id} ORDER BY gbs.count DESC LIMIT #{head}, #{show_limit}"
    end
    sql = "SELECT g.* FROM galleries g INNER JOIN gallery_view_statistics as gbs ON g.id = gbs.gallery_id INNER JOIN gallery_tag_maps as gtm ON g.id = gtm.gallery_id INNER JOIN gallery_tags as gt ON gtm.gallery_tag_id = gt.id #{where}"
    contents = ActiveRecord::Base.connection.select_all(sql)
    if contents != nil
      return contents.to_hash
    end
    return null
  end

  def self.grid_contents_sorted_by_bookmarkcount(head, show_limit, date, tag_id)
    cond = ''
    if date != nil || tag_id != nil
      if date != nil
        cond = "DATEDIFF(#{date}, gbs.view_day) == 0"
      end
      if tag_id != nil
        if cond.length > 0
          cond += " AND gt.id = #{tag_id}"
        else
          cond = "gt.id = #{tag_id}"
        end
      end
      cond = "WHERE #{cond}"
    end
    where = "#{cond} ORDER BY gbs.count DESC LIMIT #{head}, #{show_limit}"
    sql = "SELECT g.* FROM galleries g INNER JOIN gallery_bookmark_statistics as gbs ON g.id = gbs.gallery_id INNER JOIN gallery_tag_maps as gtm ON g.id = gtm.gallery_id INNER JOIN gallery_tags as gt ON gtm.gallery_tag_id = gt.id #{where}"
    contents = ActiveRecord::Base.connection.select_all(sql)
    if contents != nil
      return contents.to_hash
    end
    return null
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

  def self.load_event_pagevalue_and_jslist(gallery_id)
    item_js_list = []
    epd = null
    # EventPageValue
    gallery_event_pages = GalleryEventPagevaluePaging.joins(:gallery, :gallery_event_pagevalue).where(gallery: {id: gallery_id})
                              .select('gallery_event_pagevalue_pagings.*, gallery_event_pagevalues.data as data')
    if gallery_event_pages.size > 0
      itemids = []
      epd = {}
      gallery_event_pages.each do |p|
        key = Const::PageValueKey::P_PREFIX + p.page_num.to_s
        epd[key] = p.data

        # JSの読み込みが必要なItemIdを調査
        JSON.parse(p.data).each do |k, v|
          if k.index(Const::PageValueKey::E_NUM_PREFIX) != nil
            item_id = v[Const::EventPageValueKey::ITEM_ID]
            if item_id != nil
              unless itemids.include?(item_id)
                itemids << item_id
              end
            end
          end
        end
      end

      item_js_list = ItemJs.extract_iteminfo(Item.find(itemids))
    end

    return epd, item_js_list
  end

  def self.load_viewcount_and_bookmarkcount(gallery_id)
    gallery_view_statistic_count = GalleryViewStatistic.find_by_gallery_id(gallery_id).group(:gallery_id).sum(:count)
    gallery_bookmark_statistic_count = GalleryBookmarkStatistic.find_by_gallery_id(gallery_id).group(:gallery_id).sum(:count)
    return gallery_view_statistic_count, gallery_bookmark_statistic_count
  end

  private_class_method :save_tag, :send_imagedata, :load_instance_pagevalue, :load_event_pagevalue_and_jslist, :load_viewcount_and_bookmarkcount
end
