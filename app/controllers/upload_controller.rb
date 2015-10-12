class UploadController < ApplicationController
  def index
    user_id = current_or_guest_user.id
    project_id = params[Const::Gallery::Key::PROJECT_ID]
    if project_id == nil || title == nil || title.length == 0
      # エラー
      @message = I18n.t('message.database.item_state.save.error')
      render
    end
    @project_id = project_id.to_i
  end
end
