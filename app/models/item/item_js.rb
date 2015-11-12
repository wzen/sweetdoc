class ItemJs

  # アイテムjsファイルのパスを取得
  # @param [String] src_name ソースファイル名
  def self.js_path(src_name)
    return "#{Rails.application.config.assets.prefix}/item/#{src_name}"
  end

  # itemレコードから情報を抽出する
  # @param [Array] item_all itemレコード配列
  def self.extract_iteminfo(item_all)
    ret = []
    item_all.each do |item|
      ret <<
          {
              item_id: item.id,
              js_src: self.js_path(item.src_name)
          }
    end

    return ret
  end

end