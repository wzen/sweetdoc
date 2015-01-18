class ItemJs
  def get_lack_js(item_type)
    return "#{Rails.application.config.assets.prefix}/item/#{Item.find(item_type).src_name}"
  end
end