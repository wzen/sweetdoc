class Project < ActiveRecord::Base
  has_many :project_gallery_maps
  has_many :user_project_maps

  def self.create(user_id, title, screen_width, screen_height)
    begin
      ActiveRecord::Base.transaction do
        user_project = UserProjectMap.find_by_user_id(user_id)
        if user_project != nil && user_project.count >= Const::Project::USER_CREATE_MAX
          # 作成上限
          return I18n.t('message.database.item_state.save.error'), null
        else
          # 作成
          p = self.new({title: title, screen_width: screen_width, screen_height: screen_height})
          p.save!
          upm = UserProjectMap.new({user_id: user_id, project_id: p.id})
          upm.save!
          return I18n.t('message.database.item_state.save.success'), p.id
        end
      end
    rescue => e
      # 更新失敗
      return I18n.t('message.database.item_state.save.error'), null
    end
  end

  def self.list(user_id)

  end

end
