require 'item/item_image'

class ConfigMenuController < ApplicationController
  include ConfigMenuConcern::Get

  def ret
  end

  def design_config
    design_config = params.fetch('designConfig', false)
    mod = params.fetch('modifiables', nil)
    if mod.present?
      modifiables = JSON.parse(mod)
    else
      modifiables = {}
    end
    item_type = params.fetch('itemType', 'other')
    @result_success = true
    @html = design_config_element(self, design_config, item_type, modifiables)
    render 'ret'
  end

  def method_values_config
    class_dist_token = params.require('classDistToken')
    method_name = params.require('methodName')
    mod = params.fetch('modifiables', nil)
    if mod.present?
      modifiables = JSON.parse(mod)
    else
      modifiables = {}
    end
    @result_success = true
    @modify_html = event_var_modify_config(self, modifiables)
    @specific_html = event_specific_config(self, class_dist_token, method_name)
  end

  def preload_image_path_select_config
    @result_success = true
    @html = render_to_string(
        partial: 'sidebar_menu/design/parts/select_image_file'
    )
    render 'ret'
  end
end
