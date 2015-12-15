require 'project/project'

class ProjectController < ApplicationController
  def create
    user_id = current_or_guest_user.id
    title = params.require(Const::Project::Key::TITLE)
    screen_size = params.require(Const::Project::Key::SCREEN_SIZE)
    @result_success, @message, @project_id, @updated_at = Project.create(user_id, title, screen_size['width'].to_i, screen_size['height'].to_i)
  end

  def list
    user_id = current_or_guest_user.id
    @result_success = true
    @list = Project.list(user_id)
  end

  def get_project_by_user_pagevalue_id
    user_id = current_or_guest_user.id
    user_pagevalue_id = params.require(Const::Project::Key::USER_PAGEVALUE_ID)
    @result_success, @message, @project = Project.get_project_by_user_pagevalue_id(user_id, user_pagevalue_id)
  end

  def admin_menu
    user_id = current_or_guest_user.id
    list = Project.list(user_id)
    @admin_html = render_to_string(
        partial: 'project/admin_menu',
        locals: {
            list: list
        }
    )
    @result_success = true
  end

  def reset
    user_id = current_or_guest_user.id
    project_id = params.require(Const::Project::Key::PROJECT_ID)
    @result_success, @message = Project.reset(user_id, project_id)
  end

  def remove
    user_id = current_or_guest_user.id
    project_id = params.require(Const::Project::Key::PROJECT_ID)
    @result_success, @message, reload_list = Project.remove(user_id, project_id)
    if reload_list.present?
      @admin_html = render_to_string(
          partial: 'project/admin_menu',
          locals: {
              list: list
          }
      )
    end
  end
end
