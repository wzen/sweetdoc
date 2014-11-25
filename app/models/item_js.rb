class ItemJs
  def get_lack_js(item_path)
    return "#{Rails.application.config.assets.prefix}/item/#{item_path}.js"
  end
end