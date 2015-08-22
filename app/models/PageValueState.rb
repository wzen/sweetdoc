class PageValueState
  def self.save_state(user_id, i_page_values, e_page_values, s_page_values)
    begin
      ActiveRecord::Base.transaction do
        ip = InstancePagevalue.new({user_id: user_id, data: i_page_values})
        ip.save!
        ep = EventPagevalue.new({user_id: user_id, data: e_page_values})
        ep.save!
        sp = SettingPagevalue.new({user_id: user_id, data: s_page_values})
        sp.save!
      end
      return t('message.database.item_state.save.success')
    rescue => e
      # 更新失敗
      return t('message.database.item_state.save.error')
    end
  end
end