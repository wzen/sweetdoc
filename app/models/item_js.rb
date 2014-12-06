class ItemJs
  def get_lack_js(item_type)
    # ハイフンを「/」にする
    item_path = Const::ITEM_PATH_LIST[item_type.to_s.to_sym].sub(/¥-/, '/')
    return "#{Rails.application.config.assets.prefix}/item/#{item_path}.js"
  end
end