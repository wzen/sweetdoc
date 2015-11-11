require 'common/const'
require 'pagevalue/page_value_state'

class PageValueStateController < ApplicationController
  def save_state
    user_id = current_or_guest_user.id
    page_count = params.require(Const::ServerStorage::Key::PAGE_COUNT).to_i
    project_id = params.require(Const::ServerStorage::Key::PROJECT_ID).to_i
    g_page_values = params.require(Const::ServerStorage::Key::GENERAL_PAGE_VALUE)
    i_page_values = params.require(Const::ServerStorage::Key::INSTANCE_PAGE_VALUE)
    e_page_values = params.require(Const::ServerStorage::Key::EVENT_PAGE_VALUE)
    s_page_values = params.require(Const::ServerStorage::Key::SETTING_PAGE_VALUE)
    new_record = params.fetch(Const::ServerStorage::Key::NEW_RECORD, false)
    @result_success, @message, @last_save_time, @updated_user_pagevalue_id = PageValueState.save_state(user_id, project_id, page_count, g_page_values, i_page_values, e_page_values, s_page_values, new_record)
  end

  def load_state
    user_id = current_or_guest_user.id
    user_pagevalue_id = params['user_pagevalue_id'].to_i
    loaded_itemids = JSON.parse(params['loaded_itemids'])
    @result_success, @item_js_list, @project_pagevalue_data, @general_pagevalue_data, @instance_pagevalue_data, @event_pagevalue_data, @setting_pagevalue_data, @message, @updated_at = PageValueState.load_state(user_id, user_pagevalue_id, loaded_itemids)
  end

  def user_pagevalue_last_updated_list
    user_id = current_or_guest_user.id
    @result_success, @user_pagevalue_list = PageValueState.user_pagevalue_last_updated_list(user_id)
  end

  def user_pagevalue_list_sorted_update
    user_id = current_or_guest_user.id
    project_id = params.require(Const::ServerStorage::Key::PROJECT_ID).to_i
    @result_success, @user_pagevalue_list = PageValueState.user_pagevalue_list_sorted_update(user_id, project_id)
  end

end
