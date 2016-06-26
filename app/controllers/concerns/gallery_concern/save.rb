require 'gallery/gallery'
require 'gallery/gallery_grid_contents'

module GalleryConcern
  module Save
    extend ActiveSupport::Concern

    def save_gallery_state(
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
                          screen_width: screen_size.present? ? screen_size['width'].to_i : nil,
                          screen_height: screen_size.present? ? screen_size['height'].to_i : nil,
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
            save_gallery_pagevalue(get_gallery_project_pagevalues(upm.id), gallery_id)
            # Tag レコード追加
            save_gallery_tag(tags, gallery_id)
          else
            # 新規作成
            # Gallery レコード追加
            g = Gallery.new({
                                access_token: SecureRandom.uuid,
                                title: title,
                                caption: caption,
                                thumbnail_img: thumbnail_img,
                                thumbnail_img_width: thumbnail_width,
                                thumbnail_img_height: thumbnail_height,
                                page_max: page_max,
                                screen_width: screen_size.present? ? screen_size['width'].to_i : nil,
                                screen_height: screen_size.present? ? screen_size['height'].to_i : nil,
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
            save_gallery_pagevalue(get_gallery_project_pagevalues(upm.id), gallery_id)
            # Tag レコード追加
            save_gallery_tag(tags, gallery_id)
            # Image GalleryIdカラムにID追加
            update_gallery_item_images_column(upm.id, gallery_id)
          end
          return true, I18n.t('message.database.item_state.save.success'), g.access_token
        end
      rescue => e
        # 更新失敗
        return false, I18n.t('message.database.item_state.save.error'), nil
      end
    end

    def save_gallery_pagevalue(pagevalues, gallery_id)
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
          gp..update_all(del_flg: true)
          GalleryGeneralPagevalue.where(id: gp.pluck(:gallery_general_pagevalue_id)).update_all(del_flg: true)
        end
        ip = GalleryInstancePagevaluePaging.where('gallery_id = ? AND page_num > ?', gallery_id, after_page_max)
        if ip.present?
          ip..update_all(del_flg: true)
          GalleryInstancePagevalue.where(id: ip.pluck(:gallery_instance_pagevalue_id)).update_all(del_flg: true)
        end
        ep = GalleryEventPagevaluePaging.where('gallery_id = ? AND page_num > ?', gallery_id, after_page_max)
        if ep.present?
          ep..update_all(del_flg: true)
          GalleryEventPagevalue.where(id: ep.pluck(:gallery_event_pagevalue_id)).update_all(del_flg: true)
        end
      end
    end


    def add_gallery_view_statistic_count(access_token, date)
      begin
        g = Gallery.find_by({access_token: access_token, del_flg: false})
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

    def add_gallery_bookmark(user_id, gallery_access_token, note, date)
      begin
        ActiveRecord::Base.transaction do
          update_statistic = false
          g = Gallery.find_by({access_token: gallery_access_token, del_flg: false})
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

    def remove_gallery_bookmark(user_id, gallery_access_token, date)
      begin
        ActiveRecord::Base.transaction do
          g = Gallery.find_by({access_token: gallery_access_token, del_flg: false})
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

    def update_gallery_last_state(user_id, tags, i_page_values, e_page_values)
      begin
        if i_page_values != 'null' && e_page_values != 'null'

          ActiveRecord::Base.transaction do
            # Instance 最新データ取得
            last_i_page_values = GalleryInstancePagevaluePaging.joins(:gallery).where(gallery: {user_id: user_id, del_flg: false})

            # Instance 追加 or 更新
            i_page_values.each do |k, v|
              page_num = v['pageNum']
              pagevalue = v['pagevalue']

              p = last_i_page_values.map { |m| m.page_num.to_i == page_num }.first
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
            extras = last_i_page_values.map { |m| m.page_num.to_i > i_page_values.length }
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

              p = last_e_page_values.map { |m| m.page_num.to_i == page_num }.first
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
            extras = last_e_page_values.map { |m| m.page_num.to_i > e_page_values.length }
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
            save_gallery_tag(tags, gallery_id)

          end
        end

        return true, I18n.t('message.database.item_state.save.success')
      rescue => e
        # 更新失敗
        return false, I18n.t('message.database.item_state.save.error')
      end
    end

    # タグ名のレコードを新規作成
    def save_gallery_tag(tags, gallery_id)
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
          save_gallery_tag_category(tags)
        end

      rescue => e
        raise e
      end
    end


    def remove_gallery_contents(user_id, gallery_access_token)
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

    def update_gallery_item_images_column(user_project_map_id, gallery_id)
      ItemImage.where(user_project_map_id: user_project_map_id, del_flg: false).update_all(gallery_id: gallery_id)
    end

    def save_gallery_tag_category(tags)
      begin
        #  API使用のため別スレッドで実行
        Parallel.each(tags, in_threads: 2) do |tag|
          ActiveRecord::Base.connection_pool.with_connection do
            loop_max = 5

            # はてなキーワードでカテゴリを調べる
            client = XMLRPC::Client.new2("http://d.hatena.ne.jp/xmlrpc")
            client.http_header_extra = {'accept-encoding' => 'identity'}
            result = client.call("hatena.setKeywordLink", {
                'body' => tag,
                #mode: 'lite',
                #score: 10
            })
            category = nil
            if result['wordlist']
              category = result['wordlist'].first['cname']
            end

            loop_count = 0
            gallery_tag = self.find(tag.id)
            while gallery_tag.blank? && loop_count <= loop_max
              sleep 0.1
              loop_count += 1
              gallery_tag = self.find(tag.id)
            end

            if gallery_tag
              gallery_tag.category = category
              gallery_tag.save!
            end
          end
        end
      rescue => e
        return
      end
    end

  end
end