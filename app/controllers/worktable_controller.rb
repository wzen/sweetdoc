require 'project/project'

class WorktableController < ApplicationController
  def index
    @common_actions = Worktable.init_common_events
  end

end
