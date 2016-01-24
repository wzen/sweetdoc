class ConfigMenu

  class OptionTemp
    FONTFAMILY = [
      'sans-serif',
      'arial',
      'arial black',
      'arial narrow',
      'arial unicode ms',
      'Century Gothic',
      'Franklin Gothic Medium',
      'Gulim',
      'Dotum',
      'Haettenschweiler',
      'Impact',
      'Ludica Sans Unicode',
      'Microsoft Sans Serif',
      'MS Sans Serif',
      'MV Boil',
      'New Gulim',
      'Tahoma',
      'Trebuchet',
      'Verdana',
      'serif',
      'Batang',
      'Book Antiqua',
      'Bookman Old Style',
      'Century',
      'Estrangelo Edessa',
      'Garamond',
      'Gautami',
      'Georgia',
      'Gungsuh',
      'Latha',
      'Mangal',
      'MS Serif',
      'PMingLiU',
      'Palatino Linotype',
      'Raavi',
      'Roman',
      'Shruti',
      'Sylfaen',
      'Times New Roman',
      'Tunga',
      'monospace',
      'BatangChe',
      'Courier',
      'Courier New',
      'DotumChe',
      'GulimChe',
      'GungsuhChe',
      'HG行書体',
      'Lucida Console',
      'MingLiU',
      'ＭＳ ゴシック',
      'ＭＳ 明朝',
      'OCRB',
      'SimHei',
      'SimSun',
      'Small Fonts',
      'Terminal',
      'fantasy',
      'alba',
      'alba matter',
      'alba super',
      'baby kruffy',
      'Chick',
      'Croobie',
      'Fat',
      'Freshbot',
      'Frosty',
      'Gloo Gun',
      'Jokewood',
      'Modern',
      'Monotype Corsiva',
      'Poornut',
      'Pussycat Snickers',
      'Weltron Urban',
      'cursive',
      'Comic Sans MS',
      'HGP行書体',
      'HG正楷書体-PRO',
      'Jenkins v2.0',
      'Script',
      ['ヒラギノ角ゴ Pro W3', 'Hiragino Kaku Gothic Pro'],
      ['ヒラギノ角ゴ ProN W3', 'Hiragino Kaku Gothic ProN'],
      ['ヒラギノ角ゴ Pro W6', 'HiraKakuPro-W6'],
      ['ヒラギノ角ゴ ProN W6', 'HiraKakuProN-W6'],
      ['ヒラギノ角ゴ Std W8', 'Hiragino Kaku Gothic Std'],
      ['ヒラギノ角ゴ StdN W8', 'Hiragino Kaku Gothic StdN'],
      ['ヒラギノ丸ゴ Pro W4', 'Hiragino Maru Gothic Pro'],
      ['ヒラギノ丸ゴ ProN W4', 'Hiragino Maru Gothic ProN'],
      ['ヒラギノ明朝 Pro W3', 'Hiragino Mincho Pro'],
      ['ヒラギノ明朝 ProN W3', 'Hiragino Mincho ProN'],
      ['ヒラギノ明朝 Pro W6', 'HiraMinPro-W6'],
      ['ヒラギノ明朝 ProN W6', 'HiraMinProN-W6'],
      'Osaka',
      ['Osaka－等幅', 'Osaka-Mono'],
      'MS UI Gothic',
      ['ＭＳ Ｐゴシック','MS PGothic'],
      ['ＭＳ ゴシック','MS Gothic'],
      ['ＭＳ Ｐ明朝', 'MS PMincho'],
      ['ＭＳ 明朝', 'MS Mincho'],
      ['メイリオ', 'Meiryo'],
      'Meiryo UI'
    ]
  end

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
    ret += _modifiables_vars_config(controller, modifiables, true)
    return "<div class='#{Const::DesignConfig::ROOT_CLASSNAME}'>#{ret}</div>"
  end

  def self.event_var_modify_config(controller, modifiables)
    return _modifiables_vars_config(controller, modifiables, false)
  end

  def self.event_specific_config(controller, class_dist_token, method_name)
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

  def self._modifiables_vars_config(controller, modifiables, is_design)
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

  private_class_method :_modifiables_vars_config
end