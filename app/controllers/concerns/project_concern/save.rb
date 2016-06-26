module ProjectConcern
  module Save

    include ItemImageConcern::Save

    def create_project(user_id, title, screen_size)
      begin
        ActiveRecord::Base.transaction do
          user_project = UserProjectMap.where(user_id: user_id, del_flg: false)
          if user_project.present? && user_project.count >= Const::Project::USER_CREATE_MAX
            # 作成上限
            return I18n.t('message.database.item_state.save.error'), null
          else
            # 作成
            p = Project.new({title: title})
            p.save!
            upm = UserProjectMap.new({user_id: user_id, project_id: p.id})
            upm.save!
            up = UserPagevalue.new({user_project_map_id: upm.id})
            up.save!
            return true, I18n.t('message.database.item_state.save.success'), p.id, up.updated_at
          end
        end
      rescue => e
        # 更新失敗
        return false, I18n.t('message.database.item_state.save.error'), nil, nil
      end
    end


    def update_project(user_id, project_id, value)
      begin
        ActiveRecord::Base.transaction do
          upm = UserProjectMap.find_by(user_id: user_id, project_id: project_id, del_flg: false)
          if upm.present?
            p = self.find(project_id)
            if p.present?
              if value['p_title'].present?
                p.title = value['p_title']
              end
              p.save!
            end
          end
          return true, I18n.t('message.database.item_state.save.success'), p.attributes
        end
      rescue => e
        # 更新失敗
        return false, I18n.t('message.database.item_state.save.error'), nil
      end
    end

    def reset_project(user_id, project_id)
      begin
        ActiveRecord::Base.transaction do
          # アイテム画像の削除
          ret, mes = remove_worktable_item_image(user_id, project_id)
          unless ret
            # 更新失敗
            return false, I18n.t('message.database.item_state.save.error')
          end
          return true, I18n.t('message.database.item_state.save.success')
        end
      rescue => e
        # 更新失敗
        return false, I18n.t('message.database.item_state.save.error')
      end

    end

    def remove_project(user_id, project_id)
      begin
        ActiveRecord::Base.transaction do
          upm = UserProjectMap.find_by(user_id: user_id, project_id: project_id, del_flg: false)
          if upm.present?
            upm.del_flg = true
            upm.save!
            p = self.find(project_id)
            if p.present?
              p.del_flg = true
              p.save!
            end
          end
          # 削除完了
          return true, I18n.t('message.database.item_state.save.success')
        end
      rescue => e
        # 更新失敗
        return false, I18n.t('message.database.item_state.save.error')
      end
    end

  end
end