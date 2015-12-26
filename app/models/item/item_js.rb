class ItemJs

  # アイテムjsファイルのパスを取得
  # @param [String] file_name ソースファイル名
  def self._js_path(user_access_token, file_name)
    return "/update_user_item_gallery/#{user_access_token}/#{file_name}"
    #return "#{Rails.application.config.assets.prefix}/item/#{file_name}"
  end

  # itemレコードから情報を抽出する
  # @param [Array] item_all itemレコード配列
  def self._extract_iteminfo(item_gallery_all)
    ret = []
    item_gallery_all.each do |item_gallery|
      ret <<
          {
              class_dist_token: item_gallery['item_gallery_access_token'],
              js_src: _js_path(item_gallery['created_user_access_token'], item_gallery['file_name']),
              class_name: item_gallery['class_name']
          }
    end

    return ret
  end

  def self.get_item_gallery(access_tokens)
    if access_tokens.blank?
      return []
    end

    begin
      ActiveRecord::Base.transaction do
        at = access_tokens
        unless access_tokens.class == Array
          at = [access_tokens]
        end
        at = "'#{at.join("','")}'"

        sql =<<-"SQL"
          SELECT ig.access_token as item_gallery_access_token, ig.file_name as file_name, ig.class_name as class_name, u.access_token as created_user_access_token
          FROM item_galleries ig INNER JOIN users u ON ig.created_user_id = u.id
          WHERE ig.del_flg = 0 AND u.del_flg = 0
          AND ig.access_token IN (#{at})
        SQL
        ret_sql = ActiveRecord::Base.connection.select_all(sql)
        ret = ret_sql.to_hash
        return _extract_iteminfo(ret)
      end
    rescue => e
      # 失敗
      return false, I18n.t('message.database.item_state.save.error')
    end
  end

  private_class_method :_extract_iteminfo, :_js_path

end