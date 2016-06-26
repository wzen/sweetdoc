module PageValueStateConcern
  module Get

    def self.load_created_projects(user_id)
      # ユーザ作成プロジェクト + サンプルプロジェクト
      select =<<-"SELECT"
      up.id as up_id,
      up.updated_at as up_updated_at,
      p.id as p_id,
      p.title as p_title,
      p.is_sample as p_is_sample
      SELECT
      sql = _user_pagevalue_sql_order_updated_desc(select, user_id)
      ret = ActiveRecord::Base.connection.select_all(sql).to_hash
      ret += _sample_project_user_pagevalue
      return true, ret
    end

    def self.user_pagevalues_and_projects_sorted_updated(user_id)
      select =<<-"SELECT"
      up.id as up_id,
      up.updated_at as up_updated_at,
      p.id as p_id,
      p.title as p_title
      SELECT
      sql = _user_pagevalue_sql_order_updated_desc(select, user_id)
      ret = ActiveRecord::Base.connection.select_all(sql).to_hash
      return true, ret
    end

    def self.user_pagevalue_list_sorted_update(user_id, project_id)
      sql =<<-"SQL"
      SELECT
      up.*
      FROM
      user_pagevalues up
      INNER JOIN
      user_project_maps upm ON up.user_project_map_id = upm.id
      WHERE upm.user_id = #{user_id.to_i} AND upm.project_id = #{project_id.to_i}
      AND up.del_flg = 0
      AND upm.del_flg = 0
      ORDER BY up.updated_at DESC
      SQL
      ret = ActiveRecord::Base.connection.select_all(sql).to_hash
      return true, ret
    end

    # ユーザの保存データを読み込む
    # @param [String] user_id ユーザID
    # @param [Array] loaded_class_dist_tokens 読み込み済みのアイテムID一覧
    def self.load_state(user_id, user_pagevalue_id, loaded_class_dist_tokens)
      sql = <<-"SQL"
      SELECT p.id as project_id, p.title as project_title, p.is_sample as is_sample_project,
             ip.data as instance_pagevalue_data,
             ep.data as event_pagevalue_data,
             gcp.data as general_common_pagevalue_data,
             gp.data as general_pagevalue_data,
             sp.autosave as setting_pagevalue_autosave, sp.autosave_time as setting_pagevalue_autosave_time, sp.grid_enable as setting_pagevalue_grid_enable, sp.grid_step as setting_pagevalue_grid_step,
             ipp.page_num as page_num,
             up.updated_at as user_pagevalues_updated_at
      FROM user_pagevalues up
      LEFT JOIN setting_pagevalues sp ON up.setting_pagevalue_id = sp.id AND sp.del_flg = 0
      INNER JOIN user_project_maps upm ON up.user_project_map_id = upm.id
      INNER JOIN projects p ON upm.project_id = p.id
      LEFT JOIN instance_pagevalue_pagings ipp ON up.id = ipp.user_pagevalue_id AND ipp.del_flg = 0
      LEFT JOIN instance_pagevalues ip ON ipp.instance_pagevalue_id = ip.id AND ip.del_flg = 0
      LEFT JOIN event_pagevalue_pagings epp ON up.id = epp.user_pagevalue_id AND ipp.page_num = epp.page_num AND epp.del_flg = 0
      LEFT JOIN event_pagevalues ep ON epp.event_pagevalue_id = ep.id AND ep.del_flg = 0
      LEFT JOIN general_common_pagevalues gcp ON up.id = gcp.user_pagevalue_id AND gcp.del_flg = 0
      LEFT JOIN general_pagevalue_pagings gpp ON up.id = gpp.user_pagevalue_id AND gpp.page_num = ipp.page_num  AND gpp.del_flg = 0
      LEFT JOIN general_pagevalues gp ON gpp.general_pagevalue_id = gp.id AND gp.del_flg = 0

      WHERE
        up.id = #{user_pagevalue_id.to_i}
      AND
        up.del_flg = 0
      AND
        upm.del_flg = 0
      AND
        p.del_flg = 0
      SQL

      ret_sql = ActiveRecord::Base.connection.select_all(sql)
      pagevalues = ret_sql.to_hash

      if pagevalues.count == 0
        message = I18n.t('message.database.item_state.load.error')
        return nil
      else
        message = I18n.t('message.database.item_state.load.success')
        spd = {}
        spd[Const::Setting::Key::GRID_ENABLE] = pagevalues.first['setting_pagevalue_grid_enable'].to_i != 0
        spd[Const::Setting::Key::GRID_STEP] = pagevalues.first['setting_pagevalue_grid_step']
        spd[Const::Setting::Key::AUTOSAVE] = pagevalues.first['setting_pagevalue_autosave'].to_i != 0
        spd[Const::Setting::Key::AUTOSAVE_TIME] = pagevalues.first['setting_pagevalue_autosave_time']

        gpd = {}
        gpd[Const::Project::Key::PROJECT_ID] = pagevalues.first['project_id']
        gpd[Const::Project::Key::TITLE] = pagevalues.first['project_title']
        gpd[Const::Project::Key::IS_SAMPLE_PROJECT] = pagevalues.first['is_sample_project'].to_i != 0
        if pagevalues.first['general_common_pagevalue_data']
          # プロジェクト要素以外のGeneralを設定
          gpd.reverse_merge!(JSON.parse(pagevalues.first['general_common_pagevalue_data']))
        end

        ipd = {}
        epd = {}
        class_dist_tokens = []
        pagevalues.each do |pagevalue|
          key = Const::PageValueKey::P_PREFIX + pagevalue['page_num'].to_s
          if pagevalue['general_pagevalue_data'].present?
            gpd[key] = JSON.parse(pagevalue['general_pagevalue_data'])
          end
          if pagevalue['instance_pagevalue_data'].present?
            ipd[key] = JSON.parse(pagevalue['instance_pagevalue_data'])
          end
          if pagevalue['event_pagevalue_data'].present?
            epd[key] = JSON.parse(pagevalue['event_pagevalue_data'])

            # 必要なClassDistTokenを調査
            class_dist_tokens = PageValueState.extract_need_load_itemclassdisttokens(epd[key])
            class_dist_tokens -= loaded_class_dist_tokens
          end
        end

        item_js_list = ItemJs.get_item_gallery(class_dist_tokens)
        return true, item_js_list, gpd, ipd, epd, spd, message, pagevalues.first['user_pagevalues_updated_at']
      end
    end

    def self._user_pagevalue_sql_order_updated_desc(select_str, user_id)
      return <<-"SQL"
      SELECT
      #{select_str}
      FROM
      user_pagevalues up
      LEFT JOIN
      setting_pagevalues sp ON up.setting_pagevalue_id = sp.id AND sp.del_flg = 0
      INNER JOIN
      user_project_maps upm ON up.user_project_map_id = upm.id
      INNER JOIN
      projects p ON upm.project_id = p.id
      INNER JOIN
      (
        SELECT upm_sub.project_id as user_project_map_project_id, MAX(up_sub.updated_at) as user_pagevalue_updated_at_max
        FROM user_pagevalues up_sub
        INNER JOIN user_project_maps upm_sub ON up_sub.user_project_map_id = upm_sub.id
        WHERE upm_sub.user_id = #{user_id.to_i}
        AND up_sub.del_flg = 0
        AND upm_sub.del_flg = 0
        GROUP BY upm_sub.project_id
      ) sub ON upm.project_id = sub.user_project_map_project_id AND up.updated_at = sub.user_pagevalue_updated_at_max
      WHERE
      up.del_flg = 0
      AND
      upm.del_flg = 0
      AND
      p.del_flg = 0
      ORDER BY up.updated_at DESC
      SQL
    end



    def self._sample_project_user_pagevalue
      if Rails.env.production?
        # Productionはキャッシュを使用
        Rails.cache.fetch('sample_project_user_pagevalue') do
          _sample_project_user_pagevalue_db_access
        end
      else
        _sample_project_user_pagevalue_db_access
      end
    end

    def self._sample_project_user_pagevalue_db_access
      sql =<<-"SQL"
      SELECT
      up.id as up_id,
      up.updated_at as up_updated_at,
      p.id as p_id,
      p.title as p_title,
      p.is_sample as p_is_sample
      FROM
      user_pagevalues up
      LEFT JOIN
      setting_pagevalues sp ON up.setting_pagevalue_id = sp.id AND sp.del_flg = 0
      INNER JOIN
      user_project_maps upm ON up.user_project_map_id = upm.id
      INNER JOIN
      projects p ON upm.project_id = p.id
      INNER JOIN
      (
        SELECT upm_sub.project_id as user_project_map_project_id, MAX(up_sub.updated_at) as user_pagevalue_updated_at_max
        FROM user_pagevalues up_sub
        INNER JOIN user_project_maps upm_sub ON up_sub.user_project_map_id = upm_sub.id
        WHERE upm_sub.user_id = #{Const::ADMIN_USER_ID}
        AND up_sub.del_flg = 0
        AND upm_sub.del_flg = 0
        GROUP BY upm_sub.project_id
      ) sub ON upm.project_id = sub.user_project_map_project_id AND up.updated_at = sub.user_pagevalue_updated_at_max
      WHERE
      up.del_flg = 0
      AND
      upm.del_flg = 0
      AND
      p.del_flg = 0
      AND
      p.is_sample = 1
      SQL
      ActiveRecord::Base.connection.select_all(sql).to_hash
    end

    def self.extract_need_load_itemclassdisttokens(event_page_value)
      dist_tokens = []
      epv = event_page_value.kind_of?(String)? JSON.parse(event_page_value) : event_page_value
      epv.each do |kk, vv|
        if kk.index(Const::PageValueKey::E_MASTER_ROOT) || kk.index(Const::PageValueKey::EF_PREFIX)
          vv.each do |k, v|
            if k.index(Const::PageValueKey::E_NUM_PREFIX).present?
              token = v[Const::EventPageValueKey::CLASS_DIST_TOKEN]
              if token.present?
                unless dist_tokens.include?(token)
                  dist_tokens << token
                end
              end
            end
          end
        end
      end
      return dist_tokens
    end

    def self.load_common_gallery_footprint(user_id, gallery_access_token)
      # 履歴情報取得
      begin
        data = {}
        ActiveRecord::Base.transaction do

          g = Gallery.find_by(access_token: gallery_access_token, del_flg: false)
          gallery_id = g.id

          fp = UserGalleryFootprint.find_by(user_id: user_id, gallery_id: gallery_id, del_flg: false)
          if fp
            data[Const::PageValueKey::PAGE_NUM] = fp.page_num
          end
        end
        return true, I18n.t('message.database.item_state.save.success'), data
      rescue => e
        # 失敗
        return false, I18n.t('message.database.item_state.save.error'), nil
      end
    end

  end
end