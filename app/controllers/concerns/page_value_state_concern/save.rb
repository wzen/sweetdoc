module PageValueStateConcern
  module Save

    def save_page_value_state(user_id,
        project_id,
        page_count,
        g_page_values,
        i_page_values,
        e_page_values,
        s_page_values,
        new_record)
      begin
        last_save_time = nil
        updated_user_pagevalue_id = nil
        if g_page_values != 'null' ||
            i_page_values != 'null' ||
            e_page_values != 'null' ||
            s_page_values != 'null'

          ActiveRecord::Base.transaction do

            # Projectのチェック
            p = Project.find(project_id)
            if p.blank? || p.is_sample
              # サンプルプロジェクトの場合は保存せず終了
              return false, I18n.t('message.database.item_state.save.success'), nil, nil
            end

            # UserPagevalue Update or Insert
            sql = <<-"SQL"
            SELECT up.id as user_pagevalue_id, up.user_project_map_id as user_project_map_id, up.setting_pagevalue_id as setting_pagevalue_id
            FROM user_pagevalues up
            INNER JOIN user_project_maps upm ON up.user_project_map_id = upm.id
            WHERE upm.user_id = #{user_id.to_i} AND upm.project_id = #{project_id.to_i}
            ORDER BY up.updated_at DESC
            LIMIT 1
            SQL
            ret = ActiveRecord::Base.connection.select_all(sql)
            saved_record = ret.to_hash.first

            # 共通設定作成
            sp = _save_setting_pagevalue(s_page_values, saved_record.present? ? saved_record['setting_pagevalue_id'] : nil)
            if saved_record.blank? || new_record
              # レコード無し or 強制作成
              upm = UserProjectMap.find_by(user_id: user_id, project_id: project_id, del_flg: false)
              up = UserPagevalue.new({
                                         user_project_map_id: upm.id,
                                         setting_pagevalue_id: sp.id
                                     })
              up.save!
              updated_user_pagevalue_id = up.id
              last_save_time = up.updated_at
            else
              updated_user_pagevalue_id = saved_record['user_pagevalue_id']
              up = UserPagevalue.find(updated_user_pagevalue_id)
              if Time.zone.now - up.created_at > Const::ServerStorage::DIVIDE_INTERVAL_MINUTES.minute
                # 期間が過ぎている場合は新規作成
                upm = UserProjectMap.find_by(user_id: user_id, project_id: project_id, del_flg: false)
                up = UserPagevalue.new({
                                           user_project_map_id: upm.id,
                                           setting_pagevalue_id: sp.id
                                       })
                up.save!
                updated_user_pagevalue_id = up.id
                last_save_time = up.updated_at
              else
                # 更新
                up.setting_pagevalue_id = sp.id
                up.touch
                up.save!
                last_save_time = up.updated_at
              end
            end

            # PageValue保存
            _save_general_pagevalue(g_page_values, page_count, updated_user_pagevalue_id)
            _save_instance_pagevalue(i_page_values, page_count, updated_user_pagevalue_id)
            _save_event_pagevalue(e_page_values, page_count, updated_user_pagevalue_id)

          end
        end

        return true, I18n.t('message.database.item_state.save.success'), last_save_time, updated_user_pagevalue_id
      rescue => e
        # 更新失敗
        return false, I18n.t('message.database.item_state.save.error'), nil, nil
      end
    end


    def save_gallery_footprint_state(user_id, gallery_access_token, page_value)
      begin
        if page_value.present? && page_value != 'null'
          ActiveRecord::Base.transaction do

            g = Gallery.find_by(access_token: gallery_access_token, del_flg: false)
            gallery_id = g.id

            # 履歴保存
            page_value.each do |k, v|
              p_search = k.index(Const::PageValueKey::P_PREFIX)
              if p_search.present?
                # ページ保存
                page_num = k.gsub(Const::PageValueKey::P_PREFIX, '').to_i
                p = UserGalleryFootprintPaging.find_by(user_id: user_id, gallery_id: gallery_id, page_num: page_num, del_flg: false)
                if p
                  u = UserGalleryFootprintPagevalue.find(p.user_gallery_footprint_pagevalue_id)
                  if u
                    u.data = v.to_json
                    u.save!
                  else
                    u = UserGalleryFootprintPagevalue.new({data: v.to_json})
                    u_id = u.save!
                    p.user_gallery_footprint_pagevalue_id = u_id
                    p.save!
                  end
                else
                  u = UserGalleryFootprintPagevalue.new({data: v.to_json})
                  u_id = u.save!
                  p = UserGalleryFootprintPaging.new({user_id: user_id,
                                                      gallery_id: gallery_id,
                                                      page_num: page_num,
                                                      user_gallery_footprint_pagevalue_id: u_id
                                                     })
                  p.save!
                end
              end
            end

            page_num = nil
            page_value.each do |k, v|
              p_search = k.index(Const::PageValueKey::P_PREFIX)
              if p_search.blank?
                if k == Const::PageValueKey::PAGE_NUM
                  page_num = v
                end
              end
            end

            fp = UserGalleryFootprint.find_by(user_id: user_id, gallery_id: gallery_id, del_flg: false)
            if fp.present?
              # Update
              fp.page_num = page_num
            else
              # Create
              fp = UserGalleryFootprint.new({
                                                user_id: user_id,
                                                gallery_id: gallery_id,
                                                page_num: page_num
                                            })
            end
            fp.save!
          end
        else
          # Delete
          # FIXME:
          fp = UserGalleryFootprint.find_by(user_id: user_id, gallery_id: gallery_id, del_flg: false)
          if fp
            fp.del_flg = true
            fp.save!
          end
        end

        return true, I18n.t('message.database.item_state.save.success')
      rescue => e
        # 更新失敗
        return false, I18n.t('message.database.item_state.save.error')
      end
    end

    private
    def _save_setting_pagevalue(save_value, update_id = nil)
      ret_sp = nil

      # 共通設定作成
      if save_value != 'null'

        grid_enable = save_value[Const::Setting::Key::GRID_ENABLE]
        if grid_enable
          grid_enable = grid_enable == 'true'
        else
          grid_enable = false
        end
        grid_step = save_value[Const::Setting::Key::GRID_STEP]
        unless grid_step
          grid_step = grid_step.to_i
        end
        autosave = save_value[Const::Setting::Key::AUTOSAVE]
        if autosave
          autosave = autosave == 'true'
        else
          autosave = false
        end
        autosave_time = save_value[Const::Setting::Key::AUTOSAVE_TIME]
        unless autosave_time
          autosave_time = autosave_time.to_f
        end

        if update_id.blank?
          # Insert
          sp = SettingPagevalue.new({
                                        autosave: autosave,
                                        autosave_time: autosave_time,
                                        grid_enable: grid_enable,
                                        grid_step: grid_step
                                    })
          sp.save!
          ret_sp = sp
        else
          # Update
          sp = SettingPagevalue.find(update_id)
          if sp.present?
            sp.autosave = autosave
            sp.autosave_time = autosave_time
            sp.grid_enable = grid_enable
            sp.grid_step = grid_step
            sp.save!
            ret_sp = sp
          end
        end
      end

      return ret_sp
    end

    def _save_general_pagevalue(save_value, page_count, update_user_pagevalue_id = nil)
      if save_value != 'null'

        common = {}
        page = {}
        save_value.each do |k, v|
          if k.index(Const::PageValueKey::P_PREFIX)
            page_num = k.gsub(Const::PageValueKey::P_PREFIX, '')
            page[page_num.to_s] = v
          else
            common[k] = v
          end
        end

        # 保存済みデータ取得
        updated = false
        if update_user_pagevalue_id.present?
          gc = GeneralCommonPagevalue.find_by(user_pagevalue_id: update_user_pagevalue_id, del_flg: false)
          if gc
            gc.data = common.to_json
            gc.save!
            updated = true
          end
        end
        unless updated
          gc = GeneralCommonPagevalue.new({
                                              user_pagevalue_id: update_user_pagevalue_id,
                                              data: common.to_json
                                          })
          gc.save!
        end

        # 保存済みデータ取得
        if update_user_pagevalue_id.blank?
          saved_record = []
        else
          saved_record = GeneralPagevaluePaging.where(user_pagevalue_id: update_user_pagevalue_id, del_flg: false)
        end

        # 新規データをInsert
        (1..page_count).each do |page_num|
          pagevalue = page[page_num.to_s]
          if pagevalue.present?
            select_saved_record = saved_record.select{|s| s['page_num'] == page_num}.first
            if select_saved_record.blank?
              # 新規作成
              ip = GeneralPagevalue.new({data: pagevalue.to_json})
              ip.save!
              ipp = GeneralPagevaluePaging.new({
                                                   user_pagevalue_id: update_user_pagevalue_id,
                                                   page_num: page_num,
                                                   general_pagevalue_id: ip.id
                                               })
              ipp.save!

            else
              # 更新
              general_pagevalue_id = select_saved_record['general_pagevalue_id']
              ip = GeneralPagevalue.find(general_pagevalue_id)
              ip.data = pagevalue.to_json
              ip.save!
            end
          end
        end
      end
    end

    def _save_instance_pagevalue(save_value, page_count, update_user_pagevalue_id = nil)
      if save_value != 'null'
        # 保存済みデータ取得
        if update_user_pagevalue_id.blank?
          saved_record = []
        else
          saved_record = InstancePagevaluePaging.where(user_pagevalue_id: update_user_pagevalue_id, del_flg: false)
        end

        # 新規データをInsert
        (1..page_count).each do |page_num|
          pagevalue = save_value[page_num.to_s]
          select_saved_record = saved_record.select{|s| s['page_num'] == page_num}.first

          if select_saved_record.blank?
            # 新規作成
            ip = InstancePagevalue.new({data: pagevalue})
            ip.save!
            ipp = InstancePagevaluePaging.new({
                                                  user_pagevalue_id: update_user_pagevalue_id,
                                                  page_num: page_num,
                                                  instance_pagevalue_id: ip.id
                                              })
            ipp.save!

          else
            # 既存レコードに存在 & 送信されたpagevalueがnilの場合は更新しない
            if pagevalue.present?
              # 更新
              instance_pagevalue_id = select_saved_record['instance_pagevalue_id']
              ip = InstancePagevalue.find(instance_pagevalue_id)
              ip.data = pagevalue
              ip.save!
            end
          end
        end
      end
    end

    def _save_event_pagevalue(save_value, page_count, update_user_pagevalue_id = nil)
      if save_value != 'null'
        # 保存済みデータ取得
        if update_user_pagevalue_id.blank?
          saved_record = []
        else
          saved_record = EventPagevaluePaging.where(user_pagevalue_id: update_user_pagevalue_id, del_flg: false)
        end

        # 新規データをInsert
        (1..page_count).each do |page_num|
          pagevalue = save_value[page_num.to_s]
          select_saved_record = saved_record.select{|s| s['page_num'] == page_num}.first

          if select_saved_record.blank?
            # 新規作成
            ep = EventPagevalue.new({data: pagevalue})
            ep.save!
            epp = EventPagevaluePaging.new({
                                               user_pagevalue_id: update_user_pagevalue_id,
                                               page_num: page_num,
                                               event_pagevalue_id: ep.id
                                           })
            epp.save!

          else
            # 既存レコードに存在 & 送信されたpagevalueがnilの場合は更新しない
            if pagevalue.present?
              # 更新
              event_pagevalue_id = select_saved_record['event_pagevalue_id']
              ep = EventPagevalue.find(event_pagevalue_id)
              ep.data = pagevalue
              ep.save!
            end
          end
        end
      end
    end
  end
end