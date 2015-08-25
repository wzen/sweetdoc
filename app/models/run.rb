class Run
  def self.init_pagevalue(params)
    instance_pagevalue = self.make_pagevalue(params, Const::PageValueKey::INSTANCE_PREFIX)
    event_pagevalue = self.make_pagevalue(params, Const::PageValueKey::E_PREFIX)
    return instance_pagevalue, event_pagevalue
  end

  def self.make_pagevalue(params, pagevalue_root)
    h = params.require(pagevalue_root.to_sym)
    html = ''
    h.each do |k, v|
      html += make_element_str(k, v, pagevalue_root)
    end
    return "<div class=#{pagevalue_root}>#{html}</div>"
  end

  def self.make_element_str(key, value, key_name)
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
    value.each do |k, v|
      ret += make_element_str(k, v, key_name)
    end

    return "<div class=#{key}>#{ret}</div>"
  end

end