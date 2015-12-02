require 'motion_check/motion_check'
require 'gallery/gallery'
require 'pagevalue/page_value_state'

class RunController < ApplicationController

  def markitup_preview
    render layout: false
  end

  def paging
    user_id = current_or_guest_user.id
    target_pages = params.require(Const::Run::Key::TARGET_PAGES)
    loaded_itemids = params.require(Const::Run::Key::LOADED_ITEM_IDS)
    if loaded_itemids != nil
      loaded_itemids = JSON.parse(loaded_itemids)
    end
    if Rails.application.routes.recognize_path(request.referer)[:controller] == "gallery"
      access_token = params.require(Const::Run::Key::ACCESS_TOKEN)
      load_footprint = params.fetch(Const::Run::Key::LOAD_FOOTPRINT, false)
      @result_success, @pagevalues, @item_js_list = Gallery.paging(user_id, access_token, target_pages, loaded_itemids, load_footprint)
    else
      user_id = current_or_guest_user.id
      user_pagevalue_id = params.require(Const::Run::Key::RUNNING_USER_PAGEVALUE_ID)
      @result_success, @pagevalues, @item_js_list = MotionCheck.paging(user_id, user_pagevalue_id, target_pages, loaded_itemids)
    end
  end

  def save_gallery_footprint
    user_id = current_or_guest_user.id
    gallery_access_token = params.require(Const::Run::Key::ACCESS_TOKEN)
    footprint_page_values = params.fetch(Const::Run::Key::FOOTPRINT_PAGE_VALUE, nil)
    @result_success, @message = PageValueState.save_gallery_footprint(user_id, gallery_access_token, footprint_page_values)
  end

  def load_common_gallery_footprint
    user_id = current_or_guest_user.id
    gallery_access_token = params.require(Const::Run::Key::ACCESS_TOKEN)
    @result_success, @message, @pagevalue_data = PageValueState.load_common_gallery_footprint(user_id, gallery_access_token)
  end

end
