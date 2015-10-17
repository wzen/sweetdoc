require 'common/const'

class Run

  def self.setup_data(user_id, general, instance, event, page_num)
    # cacheに保存
    Rails.cache.write("user_id:#{user_id}-general", general, expires_in: 1.hour)
    Rails.cache.write("user_id:#{user_id}-instance", instance, expires_in: 1.hour)
    Rails.cache.write("user_id:#{user_id}-event", event, expires_in: 1.hour)

    general_pagevalues = make_pagevalue(general, Const::PageValueKey::G_PREFIX)
    instance_pagevalues = make_pagevalue_with_pagenum(instance, Const::PageValueKey::INSTANCE_PREFIX, page_num)
    event_pagevalues = make_pagevalue_with_pagenum(event, Const::PageValueKey::E_SUB_ROOT, page_num)
    creator = User.find(user_id)
    return {
        general_pagevalues: general_pagevalues,
        instance_pagevalues: instance_pagevalues,
        event_pagevalues: event_pagevalues,
    }, creator
  end

  def self.make_pagevalue(root, pagevalue_root)
    html = ''
    root.each do |k, v|
      html += make_element_str(k, v, pagevalue_root)
    end
    return "<div class=#{pagevalue_root}>#{html}</div>"
  end

  def self.make_pagevalue_with_pagenum(root, pagevalue_root, page_num)
    html = ''
    root.each do |k, v|
      if k.delete(Const::PageValueKey::P_PREFIX).to_i == page_num
        html += make_element_str(k, v, pagevalue_root)
      end
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