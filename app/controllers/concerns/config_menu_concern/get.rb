module ConfigMenuConcern
  module Get

    def design_config_element(controller, design_config, item_type, modifiables)
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
      ret += _modifiables_vars_config(controller, modifiables, true)
      return "<div class='#{Const::DesignConfig::ROOT_CLASSNAME}'>#{ret}</div>"
    end

    def event_var_modify_config(controller, modifiables)
      return _modifiables_vars_config(controller, modifiables, false)
    end

    def event_specific_config(controller, class_dist_token, method_name)
      dir = 'sidebar_menu/event/specific_values'
      temp_name = "#{class_dist_token.to_s.downcase}_#{method_name.to_s.downcase}"
      # TODO: 生HTMLを取得できるようにする
      # FIXME: lookup_contextで判定できなかったため、暫定として例外を使用
      begin
        temp = "#{dir}/#{temp_name}"
        ret = controller.render_to_string(
            partial: temp
        )
        return ret
      rescue => e
        # テンプレート無し
        return ''
      end
    end

    private
    def _modifiables_vars_config(controller, modifiables, is_design)
      ret = nil
      dir = is_design ? 'design' : 'event'
      modifiables.each do |var, v|
        temp_name = ''
        if v[Const::ItemActionPropertiesKey::TYPE] == Const::ItemDesignOptionType::NUMBER
          temp_name = 'slider'
        elsif v[Const::ItemActionPropertiesKey::TYPE] == Const::ItemDesignOptionType::STRING
          temp_name = 'textbox'
        elsif v[Const::ItemActionPropertiesKey::TYPE] == Const::ItemDesignOptionType::COLOR
          temp_name = 'color'
        elsif v[Const::ItemActionPropertiesKey::TYPE] == Const::ItemDesignOptionType::SELECT_FILE
          temp_name = 'select_file'
        elsif v[Const::ItemActionPropertiesKey::TYPE] == Const::ItemDesignOptionType::SELECT_IMAGE_FILE
          temp_name = 'select_image_file'
        elsif v[Const::ItemActionPropertiesKey::TYPE] == Const::ItemDesignOptionType::SELECT
          temp_name = 'select'
        elsif v[Const::ItemActionPropertiesKey::TYPE] == Const::ItemDesignOptionType::BOOLEAN
          temp_name = 'checkbox'
        end
        temp = "sidebar_menu/#{dir}/parts/#{temp_name}"
        value = v

        if value[Const::ItemActionPropertiesKey::TEMP].present?
          if value[Const::ItemActionPropertiesKey::TEMP] == Const::ItemOptionTempType::FONTFAMILY
            value[Const::ItemActionPropertiesKey::OPTIONS] = ConfigMenu::OptionTemp::FONTFAMILY
          end
        end

        l_value = v[I18n.locale.to_s]
        if l_value
          value.merge!(l_value)
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

        if v[Const::ItemActionPropertiesKey::MODIFIABLE_CHILDREN].present?
          # ChildrenをWrap
          wrapper = ''
          v[Const::ItemActionPropertiesKey::MODIFIABLE_CHILDREN].each do |cKey, cValue|
            if cKey.present?
              wrapper +=<<-"WRAPPER"
             <div class='#{Const::ConfigMenu::Modifiable::CHILDREN_WRAPPER_CLASS.gsub('@parentvarname', var).gsub('@childrenkey', cKey)}'>
               #{_modifiables_vars_config(controller, cValue, is_design)}
             </div>
              WRAPPER
            end
          end
          ret += wrapper.html_safe
        end

      end
      if ret.present?
        return ret
      else
        return ''
      end
    end
  end
end