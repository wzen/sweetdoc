module ItemImageConcern
  module Save

    def create_item_image(user_id, project_id, item_obj_id, event_dist_id, file_path, url)
      begin
        ActiveRecord::Base.transaction do
          if file_path.blank? && url.blank?
            return false, I18n.t('message.database.item_state.save.error'), nil
          end
          if file_path.present?
            # ローカルファイルパスを優先して登録
            url = nil
          end

          # UserProjectMap確認
          p = Project.find(project_id)
          if p.present? && !p.is_sample
            upm = UserProjectMap.find_by(user_id: user_id, project_id: project_id, del_flg: false)
            if upm.blank?
              return false, I18n.t('message.database.item_state.save.error'), nil
            end
            upm_id = upm.id
          else
            upm_id = Const::SAMPLE_PROJECT_USER_PROJECT_MAP_ID
          end

          # 存在チェック
          image = self.find_by(user_project_map_id: upm_id, item_obj_id: item_obj_id, event_dist_id: event_dist_id, del_flg: false)
          if image.present?
            # 更新
            image.file_path = file_path
            image.link_url = url
          else
            # 作成
            image = self.new
            image.user_project_map_id = upm_id
            image.item_obj_id = item_obj_id
            image.event_dist_id = event_dist_id
            image.file_path = file_path
            image.link_url = url
          end
          image.save!

          ret_url = nil
          if file_path.present?
            ret_url = image.file_path.url
          else
            ret_url = url
          end
          return true, I18n.t('message.database.item_state.save.success'), ret_url
        end
      rescue => e
        # 更新失敗
        return false, I18n.t('message.database.item_state.save.error'), nil
      end
    end

    def remove_worktable_item_image(user_id, project_id, item_obj_id = nil)
      begin
        ActiveRecord::Base.transaction do
          upm = UserProjectMap.find_by(user_id: user_id, project_id: project_id, del_flg: false)
          if upm.blank?
            return false, I18n.t('message.database.item_state.save.error')
          end
          if item_obj_id.blank?
            ItemImage.where(user_project_map_id: upm.id).destroy_all
          else
            ItemImage.where(user_project_map_id: upm.id, item_obj_id: item_obj_id).destroy_all
          end

          return true, I18n.t('message.database.item_state.save.success')
        end
      rescue => e
        # 更新失敗
        return false, I18n.t('message.database.item_state.save.error')
      end
    end

    def remove_gallery_item_image(user_id, gallery_id)
      begin
        ActiveRecord::Base.transaction do
          ItemImage.where(gallery_id: gallery_id).destroy_all
          return true, I18n.t('message.database.item_state.save.success')
        end
      rescue => e
        # 更新失敗
        return false, I18n.t('message.database.item_state.save.error')
      end
    end
  end
end