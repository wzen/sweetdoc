class Run
  def self.init_timeline_pagevalue(params)
    h = params.require(Const::PageValueKey::TE_PREFIX.to_sym)
    html = ''
    h.each do |k, v|
      html += make_element_str(k, v, Const::PageValueKey::TE_PREFIX)
    end
    return "<div class=#{Const::PageValueKey::TE_PREFIX}>#{html}</div>"
  end

  def self.make_element_str(key, value, key_name)
    key_name += "[#{key}]"
    if value.class != ActiveSupport::HashWithIndifferentAccess && value.class != Hash && value.class != Array
      # サニタイズ
      val = ERB::Util.html_escape(value)
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