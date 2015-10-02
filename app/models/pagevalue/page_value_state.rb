require 'common/const'
require 'item/item'
require 'item/item_js'
require 'pagevalue/event_pagevalue'
require 'pagevalue/event_pagevalue_paging'
require 'pagevalue/instance_pagevalue'
require 'pagevalue/instance_pagevalue_paging'
require 'pagevalue/setting_pagevalue'
require 'pagevalue/user_pagevalue'

class PageValueState
  def self.save_state(user_id, project_id, page_count, i_page_values, e_page_values, s_page_values)
    begin
      if i_page_values != 'null' || e_page_values != 'null' || s_page_values != 'null'

        ActiveRecord::Base.transaction do

          # UserPagevalue Update or Insert
          sql = <<-"SQL"
            SELECT up.id as user_pagevalue_id, up.user_project_map_id as user_project_map_id, up.setting_pagevalue_id as setting_pagevalue_id
            FROM user_pagevalues up
            INNER JOIN user_project_maps upm ON up.user_project_map_id = upm.id
            WHERE upm.user_id = #{user_id} AND upm.project_id = #{project_id}
          SQL
          ret = ActiveRecord::Base.connection.select_all(sql)
          saved_record = ret.to_hash.first
          if saved_record == nil
            # 共通設定作成
            sp_id = save_setting_pagevalue(s_page_values)
            upm = UserProjectMap.find_by(user_id: user_id, project_id: project_id)
            up = UserPagevalue.new({
                                       user_project_map_id: upm.id,
                                       setting_pagevalue_id: sp_id
                                   })
            up.save!
            updated_user_pagevalue_id = up.id
          else
            # 共通設定更新
            save_setting_pagevalue(s_page_values, saved_record['setting_pagevalue_id'])
            updated_user_pagevalue_id = saved_record['user_pagevalue_id']
          end

          # PageValue保存
          save_instance_pagevalue(i_page_values, page_count, updated_user_pagevalue_id)
          save_event_pagevalue(e_page_values, page_count, updated_user_pagevalue_id)

          # UserPageValueのupdate_at更新
          up = UserPagevalue.find(updated_user_pagevalue_id)
          if up != nil
            up.touch
            up.save!
          end
        end
      end

      return I18n.t('message.database.item_state.save.success')
    rescue => e
      # 更新失敗
      return I18n.t('message.database.item_state.save.error')
    end
  end

  def self.get_user_pagevalue_save_list(user_id, project_id)
    sql = last_user_pagevalue_search_sql(user_id, project_id)
    ret = ActiveRecord::Base.connection.select_all(sql).to_hash
    return ret
  end

  # ユーザの保存データを読み込む
  # @param [String] user_id ユーザID
  # @param [Array] loaded_itemids 読み込み済みのアイテムID一覧
  def self.load_state(user_id, user_pagevalue_id, loaded_itemids)
    sql = <<-"SQL"
      SELECT p.title as project_title, p.screen_width as project_screen_width, p.screen_height as project_screen_height,
             ip.data as instance_pagevalue_data, ep.data as event_pagevalue_data, sp.data as setting_pagevalue_data,
             ipp.page_num as page_num
      FROM user_pagevalues up
      LEFT JOIN setting_pagevalues sp ON up.setting_pagevalue_id = sp.id AND sp.del_flg = 0
      INNER JOIN user_project_maps upm ON up.user_project_map_id = upm.id
      INNER JOIN projects p ON upm.project_id = p.id
      INNER JOIN instance_pagevalue_pagings ipp ON up.id = ipp.user_pagevalue_id
      INNER JOIN instance_pagevalues ip ON ipp.instance_pagevalue_id = ip.id
      INNER JOIN event_pagevalue_pagings epp ON up.id = epp.user_pagevalue_id AND ipp.page_num = epp.page_num
      INNER JOIN event_pagevalues ep ON epp.event_pagevalue_id = ep.id
      WHERE
        up.id = #{user_pagevalue_id}
      AND
        up.del_flg = 0
      AND
        upm.del_flg = 0
      AND
        p.del_flg = 0
      AND
        ipp.del_flg = 0
      AND
        ip.del_flg = 0
      AND
        epp.del_flg = 0
      AND
        ep.del_flg = 0
    SQL

    ret_sql = ActiveRecord::Base.connection.select_all(sql)
    pagevalues = ret_sql.to_hash

    if pagevalues.count == 0
      message = I18n.t('message.database.item_state.load.error')
      return nil
    else
      message = I18n.t('message.database.item_state.load.success')

      ppd = {}
      ppd[Const::Project::Key::TITLE] = pagevalues.first['project_title']
      ppd[Const::Project::Key::SCREEN_WIDTH] = pagevalues.first['project_screen_width']
      ppd[Const::Project::Key::SCREEN_HEIGHT] = pagevalues.first['project_screen_height']
      spd = pagevalues.first['setting_pagevalue_data']

      ipd = {}
      epd = {}
      itemids = []
      pagevalues.each do |pagevalue|
        key = Const::PageValueKey::P_PREFIX + pagevalue['page_num'].to_s
        if pagevalue['instance_pagevalue_data'] != nil
          ipd[key] = pagevalue['instance_pagevalue_data']
        end
        if pagevalue['event_pagevalue_data'] != nil
          epd[key] = pagevalue['event_pagevalue_data']

          # 必要なItemIdを調査
          JSON.parse(epd[key]).each do |k, v|
            if k.index(Const::PageValueKey::E_NUM_PREFIX) != nil
              item_id = v[Const::EventPageValueKey::ITEM_ID]
              if item_id != nil
                unless loaded_itemids.include?(item_id)
                  itemids << item_id
                end
              end
            end
          end

        end
      end
      item_js_list = ItemJs.extract_iteminfo(Item.find(itemids))
      return item_js_list, ppd, ipd, epd, spd, message
    end
  end

  def self.last_user_pagevalue_search_sql(user_id, project_id = nil)
    project_filter = ''
    if project_id != nil && project_id != ''
      project_filter = "AND ump_sub.project_id = #{project_id}"
    end

    return <<-"SQL"
      SELECT
      up.*
      FROM
      user_pagevalues up
      INNER JOIN
      setting_pagevalues sp ON up.setting_pagevalue_id = sp.id
      INNER JOIN
      user_project_maps upm ON up.user_project_map_id = upm.id
      INNER JOIN
      projects p ON upm.project_id = p.id
      INNER JOIN
      (
        SELECT upm_sub.project_id as user_project_map_project_id, MAX(up_sub.updated_at) as user_pagevalue_updated_at_max
        FROM user_pagevalues up_sub
        INNER JOIN user_project_maps upm_sub ON up_sub.user_project_map_id = upm_sub.id
        WHERE upm_sub.user_id = 2

        AND up_sub.del_flg = 0
        AND upm_sub.del_flg = 0
        GROUP BY upm_sub.project_id
      ) sub ON upm.project_id = sub.user_project_map_project_id AND up.updated_at = sub.user_pagevalue_updated_at_max
      WHERE
      up.del_flg = 0
      AND
      sp.del_flg = 0
      AND
      upm.del_flg = 0
      AND
      p.del_flg = 0
    SQL
  end

  def self.save_setting_pagevalue(save_value, update_id = nil)
    ret_id = nil

    # 共通設定作成
    if save_value != 'null'
      if update_id == nil
        # Insert
        sp = SettingPagevalue.new({data: save_value})
        sp.save!
        ret_id = sp.id
      else
        # Update
        sp = SettingPagevalue.find(update_id)
        if sp != nil
          sp.data = save_value
          sp.save!
          ret_id = sp.id
        end
      end
    end

    return ret_id
  end

  def self.save_instance_pagevalue(save_value, page_count, update_user_pagevalue_id = nil)
    if save_value != 'null'
      # 保存済みデータ取得
      if update_user_pagevalue_id == nil
        saved_record = []
      else
        saved_record = InstancePagevaluePaging.where(user_pagevalue_id: update_user_pagevalue_id)
      end

      # 新規データをInsert
      (1..page_count).each do |page_num|
        pagevalue = save_value[page_num.to_s]
        select_saved_record = saved_record.select{|s| s['page_num'] == page_num}.first

        if select_saved_record == nil
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
          if pagevalue != nil
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

  def self.save_event_pagevalue(save_value, page_count, update_user_pagevalue_id = nil)
    if save_value != 'null'
      # 保存済みデータ取得
      if update_user_pagevalue_id == nil
        saved_record = []
      else
        saved_record = EventPagevaluePaging.where(user_pagevalue_id: update_user_pagevalue_id)
      end

      # 新規データをInsert
      (1..page_count).each do |page_num|
        pagevalue = save_value[page_num.to_s]
        select_saved_record = saved_record.select{|s| s['page_num'] == page_num}.first

        if select_saved_record == nil
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
          if pagevalue != nil
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

  private_class_method :last_user_pagevalue_search_sql, :save_setting_pagevalue, :save_instance_pagevalue, :save_event_pagevalue
end