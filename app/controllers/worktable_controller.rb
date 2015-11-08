require 'common/const'
require 'project/project'

class WorktableController < ApplicationController
  def index
    # Constantの設定
    init_const

    @common_actions = Worktable.init_common_events
  end

  def design_config
    design_config = params.fetch('designConfig', nil)
    @result_success = true
    html = ''
    if design_config
      html = Worktable.get_design_config(design_config)
    end
    @html = "<div class='#{Const::DesignConfig::ROOT_CLASSNAME}'>#{html}</div>"
  end

end
