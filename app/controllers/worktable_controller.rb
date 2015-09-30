require 'common/const'

class WorktableController < ApplicationController
  def index
    # Constantの設定
    init_const

    @common_actions = Worktable.init_common_events
  end

  def create_project
    title = params[Const::Project::Key::TITLE]
    screen_width = params[Const::Project::Key::SCREEN_WIDTH]
    screen_height = params[Const::Project::Key::SCREEN_HEIGHT]
    @message, @project_id = Project.create(title, screen_width, screen_height)
  end

end
