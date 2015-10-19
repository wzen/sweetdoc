require 'pagevalue/user_pagevalue'
require 'project/user_project_map'

class Project < ActiveRecord::Base
  has_many :project_gallery_maps
  has_many :user_project_maps

  def self.create(user_id, title, screen_width, screen_height)
    begin
      ActiveRecord::Base.transaction do
        user_project = UserProjectMap.where(user_id: user_id)
        if user_project != nil && user_project.count >= Const::Project::USER_CREATE_MAX
          # 作成上限
          return I18n.t('message.database.item_state.save.error'), null
        else
          # 作成
          p = self.new({title: title, screen_width: screen_width, screen_height: screen_height})
          p.save!
          upm = UserProjectMap.new({user_id: user_id, project_id: p.id})
          upm.save!
          up = UserPagevalue.new({user_project_map_id: upm.id})
          up.save!
          return I18n.t('message.database.item_state.save.success'), p.id, up.updated_at
        end
      end
    rescue => e
      # 更新失敗
      return I18n.t('message.database.item_state.save.error'), nil, nil
    end
  end

  def self.list(user_id)
    sql = <<-"SQL"
      SELECT p.title as #{Const::Project::Key::TITLE}, up.id as #{Const::Project::Key::USER_PAGEVALUE_ID}, up.updated_at as #{Const::Project::Key::USER_PAGEVALUE_UPDATED_AT}
      FROM user_project_maps upm
      INNER JOIN user_pagevalues up ON upm.id = up.user_project_map_id
      INNER JOIN projects p ON p.id = upm.project_id
      WHERE
        upm.user_id = #{user_id}
      AND
        upm.del_flg = 0
      AND
        up.del_flg = 0
      ORDER BY up.updated_at DESC
    SQL
    ret_sql = ActiveRecord::Base.connection.select_all(sql)
    if ret_sql != nil
      return ret_sql.to_hash
    end

    return null
  end

end
