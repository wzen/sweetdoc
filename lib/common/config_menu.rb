class ConfigMenu

  def self.design_config(controller, design_config, item_type, modifiables)
    ret = controller.render_to_string(
        partial: 'sidebar_menu/design/parts/common'
    )
    if design_config
      name = nil
      if item_type == 'canvas'
        name = 'canvas_design_tool'
      elsif item_type == 'css'
        name = 'css_design_tool'
      end
      if name.present?
        ret += controller.render_to_string(
            partial: "sidebar_menu/design/parts/#{name}"
        )
      end
    end
    ret += _modifiables_vars_config(controller, modifiables)
    return "<div class='#{Const::DesignConfig::ROOT_CLASSNAME}'>#{ret}</div>"
  end

  def self.event_var_modify_config(controller, modifiables)
    return _modifiables_vars_config(controller, modifiables)
  end

  def self._modifiables_vars_config(controller, modifiables)
    ret = nil
    modifiables.each do |var, v|
      temp = ''
      if v['type'] == Const::ItemDesignOptionType::NUMBER
        temp = 'sidebar_menu/event/parts/slider'
      elsif v['type'] == Const::ItemDesignOptionType::STRING
        temp = 'sidebar_menu/event/parts/textbox'
      elsif v['type'] == Const::ItemDesignOptionType::COLOR
        temp = 'sidebar_menu/event/parts/color'
      elsif v['type'] == Const::ItemDesignOptionType::SELECT_FILE
        temp = 'sidebar_menu/design/parts/select_file'
      end
      value = v
      l_value = v[I18n.locale.to_s]
      if l_value
        value.update!(l_value)
      end
      if ret.blank?
        ret = controller.render_to_string(
            partial: temp,
            locals: {
                var_name: var,
                value: value
            }
        )
      else
        ret += controller.render_to_string(
            partial: temp,
            locals: {
                var_name: var,
                value: value
            }
        )
      end

    end
    if ret.present?
      return ret
    else
      return ''
    end
  end

  private_class_method :_modifiables_vars_config
end