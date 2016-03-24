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

  def upload_thumbnail
    user_id = current_or_guest_user.id
    file_path = params[:file_path]
    # ファイルサイズ確認
    size = file_path.size
    if file_path.size > 1000000 * Const::THUMBNAIL_FILESIZE_MAX_MB
      @result_success, @message, @image_url = false, I18n.t('upload_confirm.thumbnail_size_error', size: Const::THUMBNAIL_FILESIZE_MAX_MB), nil
    else
      @result_success, @message, @image_url =  true, '', Base64.encode64(file_path.read)
    end
  end
end
