class Run
  def self.init_timeline_pagevalue(params)
    h = {}
    params.each do |key, value|
      if key.to_s.start_with?('timeline_event:')
        h = set_timeline_pagevalue(h, key, value)
      end
    end
    html = ''
    h.each do |k, v|
      te_num = nil
      if k.to_s.start_with?(Const::PageValueKey::TE_NUM_PREFIX)
        te_num = k.to_s[Const::PageValueKey::TE_NUM_PREFIX.length .. k.to_s.length - 1]
      end
      html += make_element_str(k, v, te_num)
    end
    return html
  end

  def self.set_timeline_pagevalue(hash, key, value)
    keys = key.to_s.split(Const::PageValueKey::PAGE_VALUES_SEPERATOR)
    r = hash
    keys.each_with_index do |key, index|
      k = key.to_s
      if keys.length - 1 == index
        r[k] = value
      else
        if r[k] == nil
          r[k] = {}
        end
        r = r[k]
      end
    end
    return hash
  end

  def self.make_element_str(key, value, te_num)
    if value.class == String || value.class == Integer
      # サニタイズ
      val = ERB::Util.html_escape(value)
      name = "name = #{input_tag_name(te_num, key)}"
      return "<input type='hidden' class='#{key}' value='#{val}' #{name} />"
    end

    ret = ''
    value.each do |k, v|
      if te_num == nil
        if k.to_s.start_with?(Const::PageValueKey::TE_NUM_PREFIX)
          te_num = k.to_s[Const::PageValueKey::TE_NUM_PREFIX.length .. k.to_s.length - 1]
        end
      end
      ret += make_element_str(k, v, te_num)
    end

    return "<div class=#{key}>#{ret}</div>"
  end

  def self.input_tag_name(timeline_num, key)
    return "#{Const::PageValueKey::TE_PREFIX}:#{Const::PageValueKey::TE_NUM_PREFIX}#{timeline_num}:#{key}"
  end

end