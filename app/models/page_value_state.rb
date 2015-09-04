class PageValueState
  def self.save_state(user_id, i_page_values, e_page_values, s_page_values)
    begin
      if i_page_values != 'null' || e_page_values != 'null' || s_page_values != 'null'

        last_user_page_values = UserPagevalue.where(user_id: user_id, del_flg: false).order('updated_at desc').first
        ActiveRecord::Base.transaction do

          # 共通設定保存
          if s_page_values != 'null'
            sp = SettingPagevalue.new({data: s_page_values})
            sp.save!
            sp_id = sp.id
          else
            if last_user_page_values != nil
              sp_id = last_user_page_values.setting_pagevalue_id
            else
              sp_id = nil
            end
          end

          # UserPagevalue Insert
          up = UserPagevalue.new({
                                     user_id: user_id,
                                     setting_pagevalue_id: sp_id
                                 })
          up.save!
          created_upv_id = up.id

          if i_page_values != 'null'
            updated_page_num = []
            # 新規データをInsert
            i_page_values.each do |k, v|
              page_num = v['pageNum']
              updated_page_num << page_num
              pagevalue = v['pagevalue']

              ip = InstancePagevalue.new({data: pagevalue})
              ip.save!
              ipp = InstancePagevaluePaging.new({
                                                    user_pagevalue_id: created_upv_id,
                                                    page_num: page_num,
                                                    instance_pagevalue_id: ip.id
                                                })
              ipp.save!
            end

            # update対象でないpagenumは古いデータを入れる
            if last_user_page_values != nil
              last_ipv_paging = InstancePagevaluePaging.where(user_pagevalue_id: last_user_page_values.id)
              if last_ipv_paging != nil
                last_ipv_paging.each do |l|
                  unless updated_page_num.include?(l.page_num)
                    ipp = InstancePagevaluePaging.new({
                                                          user_pagevalue_id: created_upv_id,
                                                          page_num: l.page_num,
                                                          instance_pagevalue_id: l.instance_pagevalue_id
                                                      })
                    ipp.save!
                  end
                end
              end
            end

          end

          if e_page_values != 'null'
            updated_page_num = []
            # 新規データをInsert
            e_page_values.each do |k, v|
              page_num = v['pageNum']
              updated_page_num << page_num
              pagevalue = v['pagevalue']

              ep = EventPagevalue.new({data: pagevalue})
              ep.save!
              epp = EventPagevaluePaging.new({
                                                    user_pagevalue_id: created_upv_id,
                                                    page_num: page_num,
                                                    event_pagevalue_id: ep.id
                                                })
              epp.save!
            end

            # update対象でないpagenumは古いデータを入れる
            if last_user_page_values != nil
              last_epv_paging = EventPagevaluePaging.where(user_pagevalue_id: last_user_page_values.id)
              if last_epv_paging != nil
                last_epv_paging.each do |l|
                  unless updated_page_num.include?(l.page_num)
                    epp = EventPagevaluePaging.new({
                                                       user_pagevalue_id: created_upv_id,
                                                       page_num: l.page_num,
                                                       event_pagevalue_id: l.event_pagevalue_id
                                                   })
                    epp.save!
                  end
                end
              end
            end
          end

        end
      end

      return I18n.t('message.database.item_state.save.success')
    rescue => e
      # 更新失敗
      return I18n.t('message.database.item_state.save.error')
    end
  end

  def self.get_user_pagevalue_save_list(user_id)
    return UserPagevalue.where(user_id: user_id).order('updated_at desc').limit(Const::UserPageValue::GET_LIMIT)
  end


  # ユーザの保存データを読み込む
  # @param [String] user_id ユーザID
  # @param [Array] loaded_itemids 読み込み済みのアイテムID一覧
  def self.get_saved_pagevalues(user_id, user_pagevalue_id, loaded_itemids)
    pagevalues = UserPagevalue.eager_load(:setting_pagevalue).where({id:user_pagevalue_id, user_id: user_id, del_flg: false})
                     .order('updated_at DESC')
                     .select('user_pagevalues.*, setting_pagevalues.*').first
    if pagevalues == nil
      message = I18n.t('message.database.item_state.load.error')
      return nil
    else
      message = I18n.t('message.database.item_state.load.success')

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

        item_action_events_all = ItemJs.find_events_by_itemid(itemids)
        item_js_list = ItemJs.extract_iae(item_action_events_all)
      else
        epd = nil
      end

      if pagevalues.setting_pagevalue != nil
        spd = pagevalues.setting_pagevalue.data
      else
        spd = nil
      end

      return item_js_list, ipd, epd, spd, message
    end
  end
end