require 'project/project'
require 'item/preload_item'

class WorktableController < ApplicationController
  def index
    @common_actions = Worktable.init_common_events
    @preload_items = PreloadItem.all.select('title, access_token, class_name')
    user_id = current_or_guest_user.id
    @using_items = ItemGallery.using_items(user_id)
  end

end
