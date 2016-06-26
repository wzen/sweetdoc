module ProjectConcern
  module Get

    def get_projects_by_user_pagevalue_id(user_id, user_pagevalue_id)
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

    def admin_project_list(controller, user_id)
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

    # private
    # def list(user_id)
    #   sql = <<-"SQL"
    #   SELECT p.title as #{Const::Project::Key::TITLE}, up.id as #{Const::Project::Key::USER_PAGEVALUE_ID}, up.updated_at as #{Const::Project::Key::USER_PAGEVALUE_UPDATED_AT}
    #   FROM user_project_maps upm
    #   INNER JOIN user_pagevalues up ON upm.id = up.user_project_map_id
    #   INNER JOIN projects p ON p.id = upm.project_id
    #   WHERE
    #     upm.user_id = #{user_id.to_i}
    #   AND
    #     upm.del_flg = 0
    #   AND
    #     up.del_flg = 0
    #   ORDER BY up.updated_at DESC
    #   SQL
    #   ret_sql = ActiveRecord::Base.connection.select_all(sql)
    #   if ret_sql.present?
    #     return ret_sql.to_hash
    #   end
    #
    #   return null
    # end
  end
end