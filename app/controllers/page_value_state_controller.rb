require 'const'

class PageValueStateController < ApplicationController
  def save_state
    user_id = params[Const::ServerStorage::Key::USER_ID]
    i_page_values = params[Const::ServerStorage::Key::INSTANCE_PAGE_VALUE]
    e_page_values = params[Const::ServerStorage::Key::EVENT_PAGE_VALUE]
    s_page_values = params[Const::ServerStorage::Key::SETTING_PAGE_VALUE]
    @message = PageValueState.save_state(user_id, i_page_values, e_page_values, s_page_values)
  end

  def load_state
    user_id = params['user_id']
    loaded_itemids = JSON.parse(params['loaded_itemids'])
    @item_state_list = ItemJs.get_user_iae_infos(user_id, loaded_itemids)
  end
end
