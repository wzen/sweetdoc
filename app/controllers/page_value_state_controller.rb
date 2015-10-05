require 'common/const'
require 'pagevalue/page_value_state'

class PageValueStateController < ApplicationController
  def save_state
    user_id = current_user.id
    page_count = params[Const::ServerStorage::Key::PAGE_COUNT].to_i
    project_id = params[Const::ServerStorage::Key::PROJECT_ID].to_i
    g_page_values = params[Const::ServerStorage::Key::GENERAL_PAGE_VALUE]
    i_page_values = params[Const::ServerStorage::Key::INSTANCE_PAGE_VALUE]
    e_page_values = params[Const::ServerStorage::Key::EVENT_PAGE_VALUE]
    s_page_values = params[Const::ServerStorage::Key::SETTING_PAGE_VALUE]
    @message, @last_save_time = PageValueState.save_state(user_id, project_id, page_count, g_page_values, i_page_values, e_page_values, s_page_values)
    #@user_pagevalue_list = PageValueState.get_user_pagevalue_save_list(user_id, project_id)
  end

  def load_state
    user_id = current_user.id
    user_pagevalue_id = params['user_pagevalue_id'].to_i
    loaded_itemids = JSON.parse(params['loaded_itemids'])
    @item_js_list, @project_pagevalue_data, @general_pagevalue_data, @instance_pagevalue_data, @event_pagevalue_data, @setting_pagevalue_data, @message = PageValueState.load_state(user_id, user_pagevalue_id, loaded_itemids)
  end

  def user_pagevalue_list
    user_id = current_user.id
    project_id = params[Const::ServerStorage::Key::PROJECT_ID].to_i
    @user_pagevalue_list = PageValueState.get_user_pagevalue_save_list(user_id, project_id)
  end

end
