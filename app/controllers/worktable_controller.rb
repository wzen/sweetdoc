require 'const'

class WorktableController < ApplicationController
  def index
    # Constantの設定
    init_const

    @common_actions = Worktable.init_common_events
  end

end
