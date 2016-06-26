class PageValueStateController < ApplicationController
  include PageValueStateConcern::Get
  include PageValueStateConcern::Save

  def save_state
    begin
    user_id = current_or_guest_user.id
    page_count = params.require(Const::ServerStorage::Key::PAGE_COUNT).to_i
    project_id = params.require(Const::ServerStorage::Key::PROJECT_ID).to_i
    g_page_values = params.fetch(Const::ServerStorage::Key::GENERAL_PAGE_VALUE, {})
    i_page_values = params.fetch(Const::ServerStorage::Key::INSTANCE_PAGE_VALUE, {})
    e_page_values = params.fetch(Const::ServerStorage::Key::EVENT_PAGE_VALUE, {})
    s_page_values = params.fetch(Const::ServerStorage::Key::SETTING_PAGE_VALUE, {})
    new_record = params.fetch(Const::ServerStorage::Key::NEW_RECORD, false)
    @result_success, @message, @last_save_time, @updated_user_pagevalue_id = save_page_value_state(user_id, project_id, page_count, g_page_values, i_page_values, e_page_values, s_page_values, new_record)
    rescue => e
      # require例外を握り潰す
    end
  end

  def load_state
    user_id = current_or_guest_user.id
    user_pagevalue_id = params['user_pagevalue_id'].to_i
    loaded_class_dist_tokens = JSON.parse(params['loaded_class_dist_tokens'])
    @result_success, @item_js_list, @general_pagevalue_data, @instance_pagevalue_data, @event_pagevalue_data, @setting_pagevalue_data, @message, @updated_at = load_page_value_state(user_id, user_pagevalue_id, loaded_class_dist_tokens)
  end

  def load_created_projects
    user_id = current_or_guest_user.id
    @result_success, @user_pagevalue_list = load_created_projects_state(user_id)
  end

  def user_pagevalue_list_sorted_update
    user_id = current_or_guest_user.id
    project_id = params.require(Const::ServerStorage::Key::PROJECT_ID).to_i
    @result_success, @user_pagevalue_list = user_pagevalues_sorted_update(user_id, project_id)
  end

end
