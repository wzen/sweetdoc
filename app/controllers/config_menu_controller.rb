require 'item/item_image'

class ConfigMenuController < ApplicationController
  def ret
  end

  def design_config
    design_config = params.fetch('designConfig', false)
    modifiables = params.fetch('modifiables', {})
    item_type = params.fetch('itemType', 'other')
    @result_success = true
    @html = ConfigMenu.design_config(self, design_config, item_type, modifiables)
    render 'ret'
  end

  def event_var_modify_config
    modifiables = params.fetch('modifiables', {})
    @result_success = true
    @html = ConfigMenu.event_var_modify_config(self, modifiables)
    render 'ret'
  end

  def preload_image_path_select_config
    @result_success = true
    @html = render_to_string(
        partial: 'sidebar_menu/design/parts/select_file'
    )
    render 'ret'
  end
end
