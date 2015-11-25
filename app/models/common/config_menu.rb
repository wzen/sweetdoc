class ConfigMenu

  def self.design_config(design_config, is_canvas, modifiables)
    ret = ApplicationController.new.render_to_string(
        partial: 'sidebar_menu/design/parts/common'
    )
    if design_config
      name = is_canvas ? 'canvas_design_tool' : 'css_design_tool'
      ret += ApplicationController.new.render_to_string(
          partial: "sidebar_menu/design/parts/#{name}"
      )
    end
    modifiables.each do |var, v|
      temp = ''
      if v['type'] == Const::ItemDesignOptionType::NUMBER
        temp = 'sidebar_menu/design/parts/slider'
      elsif v['type'] == Const::ItemDesignOptionType::STRING
        temp = 'sidebar_menu/design/parts/textbox'
      elsif v['type'] == Const::ItemDesignOptionType::COLOR
        temp = 'sidebar_menu/design/parts/color'
      end
      value = v
      l_value = v[I18n.locale]
      if l_value
        value.update!(l_value)
      end
      ret += ApplicationController.new.render_to_string(
          partial: temp,
          locals: {
              var_name: var,
              value: value
          }
      )
    end
    return "<div class='#{Const::DesignConfig::ROOT_CLASSNAME}'>#{ret}</div>"
  end

  def self.event_var_modify_config(modifiables)
    ret = ''
    modifiables.each do |var, v|
      temp = ''
      if v['type'] == Const::ItemDesignOptionType::NUMBER
        temp = 'sidebar_menu/event/parts/slider'
      elsif v['type'] == Const::ItemDesignOptionType::STRING
        temp = 'sidebar_menu/event/parts/textbox'
      elsif v['type'] == Const::ItemDesignOptionType::COLOR
        temp = 'sidebar_menu/event/parts/color'
      end
      value = v
      l_value = v[I18n.locale.to_s]
      if l_value
        value.update!(l_value)
      end
      ret += ApplicationController.new.render_to_string(
          partial: temp,
          locals: {
              var_name: var,
              value: value
          }
      )
    end
    return ret
  end
end