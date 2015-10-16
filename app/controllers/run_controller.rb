require 'common/const'

class RunController < ApplicationController

  def markitup_preview
    render layout: false
  end

  def paging
    target_pages = params['targetPages']
    loaded_itemids = params[Const::Run::Key::LOADED_ITEM_IDS]
    if :motion_check_controller?
      user_id = current_or_guest_user.id
      project_id = params[Const::Gallery::Key::PROJECT_ID]
      @pagevalues, @item_js_list = MotionCheck.paging(user_id, project_id, target_pages, loaded_itemids)
    else
      access_token = params[Const::Gallery::Key::GALLERY_ACCESS_TOKEN]
      @pagevalues, @item_js_list = Gallery.load_page_contents(access_token, target_pages, loaded_itemids)
    end
  end

end
