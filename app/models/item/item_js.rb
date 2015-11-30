class ItemJs

  # アイテムjsファイルのパスを取得
  # @param [String] file_name ソースファイル名
  def self.js_path(file_name)
    return "#{Rails.application.config.assets.prefix}/item/#{file_name}"
  end

  # itemレコードから情報を抽出する
  # @param [Array] item_all itemレコード配列
  def self.extract_iteminfo(item_all)
    ret = []
    item_all.each do |item|
      ret <<
          {
              item_id: item.id,
              js_src: self.js_path(item.file_name)
          }
    end

    return ret
  end

end