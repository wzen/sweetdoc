require 'project/project'
require 'item/preload_item'
require 'item_gallery/item_gallery'
require 'action_event/common_action'

class WorktableController < ApplicationController
  include ItemGalleryConcern::Get

  def index
    @common_actions = CommonAction.get_all
    @preload_items = PreloadItem.get_all
    user_id = current_or_guest_user.id
    @using_items = using_item_galleries(user_id)
  end

end
