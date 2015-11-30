class UploadController < ApplicationController
  def index
    # Constantの設定
    init_const

    # FIXME: ユーザ判定
    user_id = current_or_guest_user.id
    project_id = params.require(Const::Gallery::Key::PROJECT_ID)
    @project_id = project_id.to_i
    @page_max = params.require(Const::Gallery::Key::PAGE_MAX)
  end

  def item
    # Constantの設定
    init_const

    # FIXME: ユーザ判定
    user_id = current_or_guest_user.id
    @user_coding_id = params.require(Const::ItemGallery::Key::USER_CODING_ID)
  end
end
