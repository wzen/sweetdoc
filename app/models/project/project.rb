require 'pagevalue/user_pagevalue'
require 'project/user_project_map'
require 'item/item_image'
require 'pagevalue/page_value_state'

class Project < ActiveRecord::Base
  has_many :project_gallery_maps
  has_many :user_project_maps

  def self.create(user_id, title, screen_size)
    begin
      ActiveRecord::Base.transaction do
        user_project = UserProjectMap.where(user_id: user_id, del_flg: false)
        if user_project.present? && user_project.count >= Const::Project::USER_CREATE_MAX
          # 作成上限
          return I18n.t('message.database.item_state.save.error'), null
        else
          # 作成
          p = self.new({title: title})
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

  # def self.set_screen_size(user_id, project_id, screen_size)
  #   if screen_size.present?
  #     # スクリーンサイズ固定
  #     upm = UserProjectMap.find_by(user_id: user_id, project_id: project_id)
  #     if upm.present?
  #       p = Project.find(project_id)
  #       p.screen_width = screen_size['width'].to_i
  #       p.screen_height = screen_size['height'].to_i
  #       p.save!
  #     end
  #   end
  # end

  def self.get_project_by_user_pagevalue_id(user_id, user_pagevalue_id)
    begin
      ActiveRecord::Base.transaction do
        sql = <<-"SQL"
          SELECT p.*
          FROM user_project_maps upm
          INNER JOIN user_pagevalues up ON upm.id = up.user_project_map_id
          INNER JOIN projects p ON p.id = upm.project_id
          WHERE
            upm.user_id = #{user_id.to_i}
          AND
            up.id = #{user_pagevalue_id.to_i}
          AND
            upm.del_flg = 0
          AND
            up.del_flg = 0
        SQL
        ret_sql = ActiveRecord::Base.connection.select_all(sql)
        if ret_sql.present? && ret_sql.count > 0
          return true, I18n.t('message.database.item_state.save.success'), ret_sql.to_hash.first
        end
        return true, I18n.t('message.database.item_state.save.success'), nil
      end
    rescue => e
      # 更新失敗
      return false, I18n.t('message.database.item_state.save.error'), nil
    end
  end

  def self.list(user_id)
    sql = <<-"SQL"
      SELECT p.title as #{Const::Project::Key::TITLE}, up.id as #{Const::Project::Key::USER_PAGEVALUE_ID}, up.updated_at as #{Const::Project::Key::USER_PAGEVALUE_UPDATED_AT}
      FROM user_project_maps upm
      INNER JOIN user_pagevalues up ON upm.id = up.user_project_map_id
      INNER JOIN projects p ON p.id = upm.project_id
      WHERE
        upm.user_id = #{user_id.to_i}
      AND
        upm.del_flg = 0
      AND
        up.del_flg = 0
      ORDER BY up.updated_at DESC
    SQL
    ret_sql = ActiveRecord::Base.connection.select_all(sql)
    if ret_sql.present?
      return ret_sql.to_hash
    end

    return null
  end

  def self.admin_project_list(controller, user_id)
    result_success, list = PageValueState.user_pagevalues_and_projects_sorted_updated(user_id)
    admin_html = []
    if result_success
      if list.present?
        admin_html = controller.render_to_string(
            partial: 'project/admin_menu',
            locals: {
                list: list
            }
        )
      else
        admin_html = controller.render_to_string(
            partial: 'project/admin_no_menu',
            locals: {
                list: list
            }
        )
      end
    end
    if admin_html.length == 0
      admin_html = controller.render_to_string(
          partial: 'project/admin_no_menu',
          locals: {
              list: list
          }
      )
    end
    return result_success, admin_html
  end

  def self.update(user_id, project_id, value)
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

  def self.reset(user_id, project_id)
    begin
      ActiveRecord::Base.transaction do
        # アイテム画像の削除
        ret, mes = ItemImage.remove_worktable_img(user_id, project_id)
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

  def self.remove(user_id, project_id)
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
