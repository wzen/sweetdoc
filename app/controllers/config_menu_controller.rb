class ConfigMenuController < ApplicationController
  def ret
  end

  def design_config
    design_config = params.fetch('designConfig', false)
    modifiables = params.fetch('modifiables', {})
    is_canvas = params.require('isCanvas') == 'true'
    @result_success = true
    @html = ConfigMenu.design_config(design_config, is_canvas, modifiables)
    render 'ret'
  end

  def event_var_modify_config
    modifiables = params.fetch('modifiables', {})
    @result_success = true
    @html = ConfigMenu.event_var_modify_config(modifiables)
    render 'ret'
  end

  def preload_image_path_select_config
    @result_success = true
    @html = render_to_string(partial: 'sidebar_menu/design/parts/select_file')
    render 'ret'
  end
end
