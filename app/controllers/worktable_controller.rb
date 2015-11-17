require 'common/const'
require 'project/project'

class WorktableController < ApplicationController
  def index
    # Constantの設定
    init_const

    @common_actions = Worktable.init_common_events
  end

  def design_config
    design_config = params.fetch('designConfig', false)
    modifiables = params.fetch('modifiables', {})
    is_canvas = params.require('isCanvas') == 'true'
    @result_success = true
    @html = Worktable.design_config(design_config, is_canvas, modifiables)
  end

  def event_var_modify_config
    modifiables = params.fetch('modifiables', {})
    @result_success = true
    @html = Worktable.event_var_modify_config(modifiables)
  end

end
