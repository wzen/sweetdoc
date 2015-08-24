class PageValueState
  def self.save_state(user_id, i_page_values, e_page_values, s_page_values)
    begin
      if i_page_values != 'null' || e_page_values != 'null' || s_page_values != 'null'

        user_page_values = UserPagevalue.where(user_id: user_id).order('updated_at desc').first

        ActiveRecord::Base.transaction do
          if i_page_values != 'null'
            ip = InstancePagevalue.new({data: i_page_values})
            ip.save!
            ip_id = ip.id
          else
            ip_id = user_page_values.instance_pagevalue_id
          end
          if e_page_values != 'null'
            ep = EventPagevalue.new({data: e_page_values})
            ep.save!
            ep_id = ep.id
          else
            ep_id = user_page_values.event_pagevalue_id
          end
          if s_page_values != 'null'
            sp = SettingPagevalue.new({data: s_page_values})
            sp.save!
            sp_id = sp.id
          else
            sp_id = user_page_values.setting_pagevalue_id
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
end