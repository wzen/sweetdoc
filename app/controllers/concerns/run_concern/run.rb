module RunConcern
  module Run

    def setup_run_data(user_id, general, instance, event, footprint, page_num)
      # cacheに保存
      # Rails.cache.write("user_id:#{user_id}-general", general, expires_in: 1.hour)
      # Rails.cache.write("user_id:#{user_id}-instance", instance, expires_in: 1.hour)
      # Rails.cache.write("user_id:#{user_id}-event", event, expires_in: 1.hour)

      general_pagevalues = make_pagevalue(general, Const::PageValueKey::G_PREFIX)
      instance_pagevalues = make_pagevalue_with_pagenum(instance, Const::PageValueKey::INSTANCE_PREFIX, page_num)
      event_pagevalues = make_pagevalue_with_pagenum(event, Const::PageValueKey::E_SUB_ROOT, page_num)
      footprint_pagevalues = make_pagevalue(footprint, Const::PageValueKey::F_PREFIX)
      creator = nil
      if user_id.present?
        c = User.find(user_id)
        creator = {
            name: c.name,
            thumbnail_img: c.thumbnail_img
        }
      else
        creator = {
            name: '',
            thumbnail_img: ''
        }
      end
      return {
          general_pagevalues: general_pagevalues,
          instance_pagevalues: instance_pagevalues,
          event_pagevalues: event_pagevalues,
          footprint_pagevalues: footprint_pagevalues
      }, creator
    end

    private
    def make_pagevalue(root, pagevalue_root)
      html = ''
      root.each do |k, v|
        html += make_element_str(k, v, pagevalue_root)
      end
      return "<div class=#{pagevalue_root}>#{html}</div>"
    end

    def make_pagevalue_with_pagenum(root, pagevalue_root, page_num)
      html = ''
      root.each do |k, v|
        if k.delete(Const::PageValueKey::P_PREFIX).to_i == page_num
          html += make_element_str(k, v, pagevalue_root)
        end
      end
      return "<div class=#{pagevalue_root}>#{html}</div>"
    end

    def make_element_str(key, value, key_name)
      key_name += "[#{key}]"
      if value.class != ActiveSupport::HashWithIndifferentAccess && value.class != Hash && value.class != Array
        if value.is_a?(Integer) || value =~ /d+.d+/
          # 整数 or 小数
          val = value
        else
          # 文字列の場合はサニタイズ
          val = value # ERB::Util.html_escape(value)
        end

        name = "name = #{key_name}"
        return "<input type='hidden' class=#{key} value='#{val}' #{name} />"
      end

      ret = ''
      if value.class == Array
        value.each_with_index do |v, idx|
          ret += make_element_str(idx, v, key_name)
        end
      else
        value.each do |k, v|
          ret += make_element_str(k, v, key_name)
        end
      end

      return "<div class=#{key}>#{ret}</div>"
    end

  end
end