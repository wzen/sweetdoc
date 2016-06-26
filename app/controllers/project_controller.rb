class ProjectController < ApplicationController
  include ProjectConcern::Get
  include ProjectConcern::Save

  def create
    user_id = current_or_guest_user.id
    title = params.require(Const::Project::Key::TITLE)
    screen_size = params.fetch(Const::Project::Key::SCREEN_SIZE, nil)
    @result_success, @message, @project_id, @updated_at = create_project(user_id, title, screen_size)
  end

  def get_project_by_user_pagevalue_id
    user_id = current_or_guest_user.id
    user_pagevalue_id = params.require(Const::Project::Key::USER_PAGEVALUE_ID)
    @result_success, @message, @project = get_projects_by_user_pagevalue_id(user_id, user_pagevalue_id)
  end

  def admin_menu
    user_id = current_or_guest_user.id
    @result_success, @admin_html = admin_project_list(self, user_id)
  end

  def update
    user_id = current_or_guest_user.id
    project_id = params.require(Const::Project::Key::PROJECT_ID)
    value = params.fetch('value', {})
    @result_success, @message, @updated_project_info = update_project(user_id, project_id, value)
    if @result_success
      @result_success, @admin_html = admin_project_list(self, user_id)
    end
  end

  def reset
    user_id = current_or_guest_user.id
    project_id = params.require(Const::Project::Key::PROJECT_ID)
    @result_success, @message = reset_project(user_id, project_id)
  end

  def remove
    user_id = current_or_guest_user.id
    project_id = params.require(Const::Project::Key::PROJECT_ID)
    @result_success, @message = remove_project(user_id, project_id)
    if @result_success
      @result_success, @admin_html = admin_project_list(self, user_id)
    end
  end
end
