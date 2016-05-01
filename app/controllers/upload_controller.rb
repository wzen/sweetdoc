require 'gallery/gallery'

class UploadController < ApplicationController
  def index
    # FIXME: ユーザ判定
    user_id = current_or_guest_user.id
    project_id = params.require(Const::Gallery::Key::PROJECT_ID)
    @project_id = project_id.to_i
    @screen_size = params.fetch(Const::Gallery::Key::SCREEN_SIZE, nil)
    @page_max = params.require(Const::Gallery::Key::PAGE_MAX)
    @uploaded_list =  Gallery.uploaded_gallery_list(user_id, project_id)
  end

  def item
    # FIXME: ユーザ判定
    user_id = current_or_guest_user.id
    @user_coding_id = params.require(Const::ItemGallery::Key::USER_CODING_ID)
  end

end
