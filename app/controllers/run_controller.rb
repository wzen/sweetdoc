require 'common/const'
require 'motion_check/motion_check'
require 'gallery/gallery'

class RunController < ApplicationController

  def markitup_preview
    render layout: false
  end

  def paging
    # Constantの設定
    init_const

    target_pages = params.require(Const::Run::Key::TARGET_PAGES)
    loaded_itemids = params.require(Const::Run::Key::LOADED_ITEM_IDS)
    if loaded_itemids != nil
      loaded_itemids = JSON.parse(loaded_itemids)
    end
    if Rails.application.routes.recognize_path(request.referer)[:controller] == "gallery"
      access_token = params.require(Const::Run::Key::ACCESS_TOKEN)
      @result_success, @pagevalues, @item_js_list = Gallery.paging(access_token, target_pages, loaded_itemids)
    else
      user_id = current_or_guest_user.id
      user_pagevalue_id = params.require(Const::Run::Key::RUNNING_USER_PAGEVALUE_ID)
      @result_success, @pagevalues, @item_js_list = MotionCheck.paging(user_id, user_pagevalue_id, target_pages, loaded_itemids)
    end
  end

end
