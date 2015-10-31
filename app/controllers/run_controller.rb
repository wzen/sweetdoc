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

    target_pages = params[Const::Run::Key::TARGET_PAGES]
    loaded_itemids = params[Const::Run::Key::LOADED_ITEM_IDS]
    if loaded_itemids != nil
      loaded_itemids = JSON.parse(loaded_itemids)
    end
    if Rails.application.routes.recognize_path(request.referer)[:controller] == "gallery"
      access_token = params[Const::Run::Key::ACCESS_TOKEN]
      @result_success, @pagevalues, @item_js_list = Gallery.paging(access_token, target_pages, loaded_itemids)
    else
      user_id = current_or_guest_user.id
      project_id = params[Const::Run::Key::PROJECT_ID]
      @result_success, @pagevalues, @item_js_list = MotionCheck.paging(user_id, project_id, target_pages, loaded_itemids)
    end
  end

end
