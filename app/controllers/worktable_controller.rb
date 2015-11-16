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
    html = Worktable.get_design_config(design_config, is_canvas, modifiables)
    @html = "<div class='#{Const::DesignConfig::ROOT_CLASSNAME}'>#{html}</div>"
  end

end
