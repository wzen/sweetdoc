class ProjectController < ApplicationController
  def create
    user_id = current_user.id
    title = params[Const::Project::Key::TITLE]
    screen_width = params[Const::Project::Key::SCREEN_WIDTH]
    screen_height = params[Const::Project::Key::SCREEN_HEIGHT]
    @message, @project_id = Project.create(user_id, title, screen_width, screen_height)
  end

  def list
    user_id = current_user.id
    @list = Project.list(user_id)
  end
end
