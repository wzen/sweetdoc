class PageValueState
  def self.save_state(user_id, i_page_values, e_page_values, s_page_values)
    begin
      if i_page_values != 'null' || e_page_values != 'null' || s_page_values != 'null'

        user_page_values = UserPagevalue.where(user_id: user_id, del_flg: false).order('updated_at desc').first

        ActiveRecord::Base.transaction do
          if i_page_values != 'null'
            ip = InstancePagevalue.new({data: i_page_values})
            ip.save!
            ip_id = ip.id
          else
            if user_page_values != nil
              ip_id = user_page_values.instance_pagevalue_id
            else
              ip_id = nil
            end
          end
          if e_page_values != 'null'
            ep = EventPagevalue.new({data: e_page_values})
            ep.save!
            ep_id = ep.id
          else
            if user_page_values != nil
              ep_id = user_page_values.event_pagevalue_id
            else
              ep_id = nil
            end
          end
          if s_page_values != 'null'
            sp = SettingPagevalue.new({data: s_page_values})
            sp.save!
            sp_id = sp.id
          else
            if user_page_values != nil
              sp_id = user_page_values.setting_pagevalue_id
            else
              sp_id = nil
            end
          end
          up = UserPagevalue.new({
                                     user_id: user_id,
                                     instance_pagevalue_id: ip_id,
                                     event_pagevalue_id: ep_id,
                                     setting_pagevalue_id: sp_id
                                 })
          up.save!
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
    pagevalues = UserPagevalue.where({id:user_pagevalue_id, user_id: user_id, del_flg: false}).order('updated_at DESC')
                     .includes(:instance_pagevalue, :event_pagevalue, :setting_pagevalue).first
    if pagevalues == nil
      message = I18n.t('message.database.item_state.load.error')
      return nil
    else
      message = I18n.t('message.database.item_state.load.success')
      item_js_list = []

      if pagevalues.instance_pagevalue != nil
        ipd = pagevalues.instance_pagevalue.data
      else
        ipd = nil
      end

      if pagevalues.event_pagevalue != nil
        epd = pagevalues.event_pagevalue.data
        itemids = []
        JSON.parse(epd).each do |k, v|
          if k.index(Const::PageValueKey::E_NUM_PREFIX) != nil
            item_id = v[Const::EventPageValueKey::ITEM_ID]
            if item_id != nil
              unless loaded_itemids.include?(item_id)
                itemids << item_id
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