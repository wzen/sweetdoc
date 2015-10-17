class UploadController < ApplicationController
  def index
    # Constantの設定
    init_const

    user_id = current_or_guest_user.id
    project_id = params[Const::Gallery::Key::PROJECT_ID]
    if project_id == nil
      # エラー
      @message = I18n.t('message.database.item_state.save.error')
      render
    end
    @project_id = project_id.to_i
    @page_max = params[Const::Gallery::Key::PAGE_MAX]
  end
end
