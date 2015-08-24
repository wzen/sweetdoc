class PageValueState
  def self.save_state(user_id, i_page_values, e_page_values, s_page_values)
    begin
      if i_page_values != 'null' || e_page_values != 'null' || s_page_values != 'null'
        ActiveRecord::Base.transaction do
          if i_page_values != 'null'
            ip = InstancePagevalue.new({data: i_page_values})
            ip.save!
          else
            ip = InstancePagevalue.find(:last)
          end
          if e_page_values != 'null'
            ep = EventPagevalue.new({data: e_page_values})
            ep.save!
          else
            ep = EventPagevalue.find(:last)
          end
          if s_page_values != 'null'
            sp = SettingPagevalue.new({data: s_page_values})
            sp.save!
          else
            sp = SettingPagevalue.find(:last)
          end
          up = UserPagevalue.new({
                                     user_id: user_id,
                                     instance_pagevalue_id: ip.id,
                                     event_pagevalue_id: ep.id,
                                     setting_pagevalue_id: sp.id
                                 })
          up.save!
        end
      end

      return t('message.database.item_state.save.success')
    rescue => e
      # 更新失敗
      return t('message.database.item_state.save.error')
    end
  end

  def self.get_user_pagevalue_save_list(user_id)
    return UserPagevalue.where(user_id: user_id).order('updated_at desc').limit(Const::UserPageValue::GET_LIMIT)
  end
end