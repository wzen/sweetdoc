require 'const'

class PageValueStateController < ApplicationController
  def save_state
    user_id = params[Const::ServerStorage::Key::USER_ID]
    i_page_values = params[Const::ServerStorage::Key::INSTANCE_PAGE_VALUE]
    e_page_values = params[Const::ServerStorage::Key::EVENT_PAGE_VALUE]
    s_page_values = params[Const::ServerStorage::Key::SETTING_PAGE_VALUE]
    @message = PageValueState.save_state(user_id, i_page_values, e_page_values, s_page_values)
    @user_pagevalue_list = PageValueState.get_user_pagevalue_save_list(user_id)
  end

  def load_state
    user_id = params['user_id']
    user_pagevalue_id = params['user_pagevalue_id']
    loaded_itemids = JSON.parse(params['loaded_itemids'])
    @item_js_list, @instance_pagevalue_data, @event_pagevalue_data, @setting_pagevalue_data, @message = PageValueState.get_saved_pagevalues(user_id, user_pagevalue_id, loaded_itemids)
  end

  def user_pagevalue_list
    user_id = params[Const::ServerStorage::Key::USER_ID]
    @user_pagevalue_list = PageValueState.get_user_pagevalue_save_list(user_id)
  end

end
