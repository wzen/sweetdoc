require 'project/project'

class ProjectController < ApplicationController
  def create
    user_id = current_or_guest_user.id
    title = params[Const::Project::Key::TITLE]
    screen_size = params[Const::Project::Key::SCREEN_SIZE]
    @result_success, @message, @project_id, @updated_at = Project.create(user_id, title, screen_size['width'].to_i, screen_size['height'].to_i)
  end

  def list
    user_id = current_or_guest_user.id
    @result_success = true
    @list = Project.list(user_id)
  end

  def admin_menu
    user_id = current_or_guest_user.id
    @result_success, @html = Project.admin_menu(user_id)
  end
end
