class ItemJs
  def get_lack_js(item_id)
    return "#{Rails.application.config.assets.prefix}/item/#{Item.find(item_id).src_name}"
  end
end