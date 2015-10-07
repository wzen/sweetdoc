class ProjectController < ApplicationController
  def create
    user_id = my_current_user.id
    title = params[Const::Project::Key::TITLE]
    screen_size = params[Const::Project::Key::SCREEN_SIZE]
    @message, @project_id = Project.create(user_id, title, screen_size['width'].to_i, screen_size['height'].to_i)
  end

  def list
    user_id = my_current_user.id
    @list = Project.list(user_id)
  end
end
