require 'project/user_project_map'

class ItemImage < ActiveRecord::Base
  mount_uploader :file_path, ItemImageUploader

  def self.create_img(user_id, project_id, item_obj_id, event_dist_id, file_path, url)
    begin
      ActiveRecord::Base.transaction do
        if file_path.blank? && url.blank?
          return nil
        end
        if file_path.present?
          # ローカルファイルパスを優先して登録
          url = nil
        end

        upm = UserProjectMap.find_by(user_id: user_id, project_id: project_id)
        if upm.blank?
          return nil
        end
        image = self.new
        image.user_project_map_id = upm.id
        image.item_obj_id = item_obj_id
        image.event_dist_id = event_dist_id
        image.file_path = file_path
        image.url = url
        image.save!
        return true, I18n.t('message.database.item_state.save.success'), image.url
      end
    rescue => e
      # 更新失敗
      return false, I18n.t('message.database.item_state.save.error'), nil
    end
  end
end
