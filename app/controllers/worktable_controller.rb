require 'project/project'
require 'item/preload_item'
require 'item_gallery/item_gallery'

class WorktableController < ApplicationController
  def index
    @common_actions = Worktable.init_common_events
    @preload_items = PreloadItem.get_all
    user_id = current_or_guest_user.id
    @using_items = ItemGallery.using_items(user_id)
  end

  def reset_project

  end
end
