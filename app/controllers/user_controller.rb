class UserController < ApplicationController
  def update_thumbnail
    result_success = nil
    message = nil
    image_url = nil
    begin
      ActiveRecord::Base.transaction do
        user = current_or_guest_user
        user_id = user.id
        file_path = params[Const::User::Key::THUMBNAIL]
        # ファイルサイズ確認
        size = file_path.size
        if file_path.size > 1000 * Const::THUMBNAIL_FILESIZE_MAX_KB
          result_success, message, image_url = false, I18n.t('upload_confirm.thumbnail_size_error', size: Const::THUMBNAIL_FILESIZE_MAX_KB), nil
        else
          user.thumbnail_img = file_path
          user.save!
          result_success, message, image_url = true, '', user.thumbnail_img.url
        end
      end
    rescue => e
      result_success, message, image_url = false, '', nil
    end

    render json: {
        result_success: result_success,
        message: message,
        image_url: image_url,
    }
  end
end
