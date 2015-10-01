require 'common/const'
require 'pagevalue/event_pagevalue'
require 'pagevalue/event_pagevalue_paging'
require 'pagevalue/instance_pagevalue'
require 'pagevalue/instance_pagevalue_paging'
require 'pagevalue/setting_pagevalue'
require 'pagevalue/user_pagevalue'

class PageValueState
  def self.save_state(user_id, project_id, i_page_values, e_page_values, s_page_values)
    begin
      if i_page_values != 'null' || e_page_values != 'null' || s_page_values != 'null'

        #last_user_page_values = UserPagevalue.where(user_id: user_id, del_flg: false).order('updated_at desc').first
        ActiveRecord::Base.transaction do

          # UserPagevalue Update or Insert
          up = UserPagevalue.includes(:user_project_map).readonly(false).where(user_project_maps: {user_id: user_id, project_id: project_id}).references(:user_project_maps)
          if up == nil
            # 共通設定作成
            sp_id = save_setting_pagevalue(s_page_values)
            up = UserPagevalue.new({
                                       user_project_map_id: up.user_project_maps.id,
                                       setting_pagevalue_id: sp_id
                                   })
            up.save!
          else
            # 共通設定更新
            save_setting_pagevalue(s_page_values, up.setting_pagevalue_id)
          end

          # PageValue保存
          save_instance_pagevalue(i_page_values, up.id)
          save_event_pagevalue(e_page_values, up.id)
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
    pagevalues = UserPagevalue.eager_load(:setting_pagevalue).where({id:user_pagevalue_id, user_id: user_id, del_flg: false})
                     .order('updated_at DESC')
                     .select('user_pagevalues.*, setting_pagevalues.*').first
    if pagevalues == nil
      message = I18n.t('message.database.item_state.load.error')
      return nil
    else
      message = I18n.t('message.database.item_state.load.success')

      if pagevalues.projects != nil
        ppd = {}
        ppd[Const::Project::Key::TITLE] = pagevalues.projects.title
        ppd[Const::Project::Key::SCREEN_WIDTH] = pagevalues.projects.screen_width
        ppd[Const::Project::Key::SCREEN_HEIGHT] = pagevalues.projects.screen_height
      else
        ppd = nil
      end

      instance_pages = InstancePagevaluePaging.joins(:user_pagevalue, :instance_pagevalue).where(user_pagevalues: {id: user_pagevalue_id})
                           .select('instance_pagevalue_pagings.*, instance_pagevalues.data as data')
      if instance_pages.size > 0
        ipd = {}
        instance_pages.each do |p|
          key = Const::PageValueKey::P_PREFIX + p.page_num.to_s
          ipd[key] = p.data
        end
      else
        ipd = nil
      end

      item_js_list = []
      event_pages = EventPagevaluePaging.joins(:user_pagevalue, :event_pagevalue).where(user_pagevalues: {id: user_pagevalue_id})
                           .select('event_pagevalue_pagings.*, event_pagevalues.data as data')
      if event_pages.size > 0
        itemids = []
        epd = {}
        event_pages.each do |p|
          key = Const::PageValueKey::P_PREFIX + p.page_num.to_s
          epd[key] = p.data

          # 必要なItemIdを調査
          JSON.parse(p.data).each do |k, v|
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

        item_js_list = ItemJs.extract_iteminfo(Item.find(itemids))
      else
        epd = nil
      end

      if pagevalues.setting_pagevalue != nil
        spd = pagevalues.setting_pagevalue.data
      else
        spd = nil
      end

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

  def self.save_instance_pagevalue(save_value, update_user_pagevalue_id = nil)
    if save_value != 'null'
      updated_page_num = []

      # 保存済みデータ取得
      saved_record = InstancePagevaluePaging.where(user_pagevalue_id: update_user_pagevalue_id).attributes

      # 新規データをInsert
      save_value.each do |k, v|
        page_num = v['pageNum']
        updated_page_num << page_num.to_i
        pagevalue = v['pagevalue']

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
          # 更新
          instance_pagevalue_id = select_saved_record['instance_pagevalue_id']
          ip = InstancePagevalue.find(instance_pagevalue_id)
          ip.data = pagevalue
          ip.save!
        end

      end

      # TODO: データ更新のデバッグ終了するまで残しておく
      # # update対象でないpagenumは古いデータを入れる
      # if last_user_page_values != nil
      #   last_ipv_paging = InstancePagevaluePaging.where(user_pagevalue_id: last_user_page_values.id)
      #   if last_ipv_paging != nil
      #     last_ipv_paging.each do |l|
      #       if !updated_page_num.include?(l.page_num) && l.page_num <= page_count.to_i
      #         ipp = InstancePagevaluePaging.new({
      #                                               user_pagevalue_id: update_user_pagevalue_id,
      #                                               page_num: l.page_num,
      #                                               instance_pagevalue_id: l.instance_pagevalue_id
      #                                           })
      #         ipp.save!
      #       end
      #     end
      #   end
      # end

    end
  end

  def self.save_event_pagevalue(save_value, update_user_pagevalue_id = nil)
    if save_value != 'null'
      updated_page_num = []
      # 保存済みデータ取得
      saved_record = EventPagevaluePaging.where(user_pagevalue_id: update_user_pagevalue_id).attributes

      # 新規データをInsert
      save_value.each do |k, v|
        page_num = v['pageNum']
        updated_page_num << page_num.to_i
        pagevalue = v['pagevalue']

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
          # 更新
          event_pagevalue_id = select_saved_record['event_pagevalue_id']
          ep = EventPagevalue.find(event_pagevalue_id)
          ep.data = pagevalue
          ep.save!
        end

      end

      # TODO: データ更新のデバッグ終了するまで残しておく
      # # update対象でないpagenumは古いデータを入れる
      # if last_user_page_values != nil
      #   last_epv_paging = EventPagevaluePaging.where(user_pagevalue_id: last_user_page_values.id)
      #   if last_epv_paging != nil
      #     last_epv_paging.each do |l|
      #       if !updated_page_num.include?(l.page_num) && l.page_num <= page_count.to_i
      #         epp = EventPagevaluePaging.new({
      #                                            user_pagevalue_id: update_user_pagevalue_id,
      #                                            page_num: l.page_num,
      #                                            event_pagevalue_id: l.event_pagevalue_id
      #                                        })
      #         epp.save!
      #       end
      #     end
      #   end
      # end
    end
  end

  private_class_method :last_user_pagevalue_search_sql, :save_setting_pagevalue, :save_instance_pagevalue, :save_event_pagevalue
end