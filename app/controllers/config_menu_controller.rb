require 'common/const'
require 'common/config_menu'

class ConfigMenuController < ApplicationController
  def design_config
    design_config = params.fetch('designConfig', false)
    modifiables = params.fetch('modifiables', {})
    is_canvas = params.require('isCanvas') == 'true'
    @result_success = true
    @html = ConfigMenu.design_config(design_config, is_canvas, modifiables)
  end

  def event_var_modify_config
    modifiables = params.fetch('modifiables', {})
    @result_success = true
    @html = ConfigMenu.event_var_modify_config(modifiables)
  end
end
