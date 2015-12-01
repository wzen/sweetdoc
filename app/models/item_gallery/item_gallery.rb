require 'coding/user_coding'
require 'item_gallery/user_item_gallery_map'
require 'item_gallery/item_gallery_tag'
require 'item_gallery/item_gallery_tag_map'

class ItemGallery < ActiveRecord::Base
  def self.index

  end

  def self.save_state(
    user_id,
    user_coding_id,
    tags,
    title,
    caption,
    update_item_gallery_id = nil
  )
    begin
      ActiveRecord::Base.transaction do
        sql =<<-"SQL"
          SELECT uc.code_filename as code_filename, uc.lang_type as lang_type, uc.id as id, u.access_token as user_access_token
          FROM user_codings uc
          INNER JOIN users u ON uc.user_id = u.id
          AND uc.id = uct.user_coding_id
          AND u.del_flg = 0
          WHERE u.id = #{user_id}
          AND uc.del_flg = 0
          AND uc.id = #{user_coding_id}
        SQL
        ret_sql = ActiveRecord::Base.connection.select_all(sql)
        ret = ret_sql.to_hash.first
        if ret != nil
          # ユーザコード読み込み & 変換
          user_access_token = ret['user_access_token']
          class_name = "C#{SecureRandom.hex(8)}"
          user_code_path = "#{UserCodeUtil.code_parentdirpath(UserCodeUtil::CODE_TYPE::ITEM_PREVIEW, user_access_token)}/#{ret['code_filename']}"
          code = ''
          File.open(user_code_path, 'r') do |file|
            file.each do |read_line|
              code += read_line.gsub(Const::ITEM_CODING_TEMP_CLASS_NAME, class_name)
            end
          end
          FileUtils.mkdir_p(UserCodeUtil.code_parentdirpath(UserCodeUtil::CODE_TYPE::ITEM_GALLERY, user_access_token)) unless File.directory?(UserCodeUtil.code_parentdirpath(UserCodeUtil::CODE_TYPE::ITEM_GALLERY, user_access_token))

          if update_item_gallery_id && (ig = ItemGallery.find_by(created_user_id: user_id, item_gallery_id: update_item_gallery_id, del_flg: false))
            # 既存コードのUpdate
            # update
            save_filename = ig.file_name
            user_code_path = "#{UserCodeUtil.code_parentdirpath(UserCodeUtil::CODE_TYPE::ITEM_GALLERY, user_access_token)}/#{save_filename}"
            File.open(user_code_path, 'w') do |file|
              file.write(code)
            end
          else
            save_filename = SecureRandom.urlsafe_base64
            user_code_path = "#{UserCodeUtil.code_parentdirpath(UserCodeUtil::CODE_TYPE::ITEM_GALLERY, user_access_token)}/#{save_filename}"
            File.open(user_code_path, 'w') do |file|
              file.write(code)
            end
            access_token = SecureRandom.urlsafe_base64
            # Insert
            ig = ItemGallery.new({
                                     access_token: access_token,
                                     created_user_id: user_id,
                                     title: title,
                                     caption: caption,
                                     class_name: class_name,
                                     public_type: Const::ItemGallery::PublicType::PUBLIC,
                                     file_name: save_filename
                                 })
            ig.save!
          end
          # 成功
          return true, I18n.t('message.database.item_state.save.success')
        else
          # 失敗
          return false, I18n.t('message.database.item_state.save.error')
        end
      end
    rescue => e
      # 失敗
      return false, I18n.t('message.database.item_state.save.error')
    end
  end

  # タグ名のレコードを新規作成
  def self.save_tag(tags, item_gallery_id)
    begin
      if tags != 'null' && tags.length > 0
        # タグ数がMAX以上のものは削除
        tags = tags.take(Const::ItemGallery::TAG_MAX)

        # タグテーブル処理
        tag_ids = []
        tags.each do |tag|
          t = ItemGalleryTag.find_by(name: tag)
          if t == nil
            # タグを新規作成
            t = ItemGalleryTag.new({
                                   name: tag
                               })
            t.save!
            tag_ids << t.id

          else
            # タグの重み付けを加算
            if t.weight
              t.weight += 1
            else
              t.weight = 1
            end

            t.save!
            tag_ids << t.id
          end
        end

        # 存在しているデータが有る場合削除
        ItemGalleryTagMap.delete_all(item_gallery_id: item_gallery_id)

        # タグマップテーブル作成
        tag_ids.each do |tag_id|
          # Insert
          map = ItemGalleryTagMap.new({
                                      item_gallery_id: item_gallery_id,
                                      item_gallery_tag_id: tag_id
                                  })
          map.save!
        end

        # タグカテゴリ設定
        ItemGalleryTag.save_tag_category(tags)
      end

    rescue => e
      raise e
    end
  end

  def self.code_filepath(item_gallery_access_token)
    begin
      ActiveRecord::Base.transaction do
        sql =<<-"SQL"
          SELECT u.access_token as created_user_access_token, ig.file_name as code_filename
          FROM users u INNER JOIN item_galleries ig ON u.id = ig.created_user_id
          WHERE ig.access_token = #{item_gallery_access_token}
          AND u.del_flg = 0
          AND ig.del_flg = 0
        SQL
        ret_sql = ActiveRecord::Base.connection.select_all(sql)
        r = ret_sql.to_hash
        if r.count > 0
          return UserCodeUtil.code_urlpath(UserCodeUtil::CODE_TYPE::ITEM_GALLERY, r.first['created_user_access_token'], r.first['code_filename'])
        else
          return nil
        end
      end
    rescue => e
      # 失敗
      return nil
    end
  end

  def self.upload_user_used(user_id, item_gallery_access_token, is_add)
    begin
      # TODO:
      ActiveRecord::Base.transaction do
        sql =<<-"SQL"
          SELECT ig.id as item_gallery_id, uigm.id as user_item_gallery_id
          FROM user_item_gallery_maps uigm
          INNER JOIN item_galleres ig ON uigm.item_gallery_id = ig.id
          WHERE uigm.user_id = #{user_id}
          AND ig.access_token = #{item_gallery_access_token}
          AND uigm.del_flg = 0
          AND ig.del_flg = 0
        SQL
        ret_sql = ActiveRecord::Base.connection.select_all(sql)
        ret = ret_sql.to_hash
        if ret.count == 0 && is_add
          # 追加処理
          uigm = UserItemGalleryMap.new({
                                            user_id: user_id,
                                            item_gallery_id: ret.first['item_gallery_id']
                                        })
          uigm.save!
          # 成功
          return true, I18n.t('message.database.item_state.save.success')
        elsif ret.count > 0 && !is_add
          # 削除処理
          uigm = UserItemGalleryMap.find(ret.first['user_item_gallery_id'])
          uigm.destroy!
          # 成功
          return true, I18n.t('message.database.item_state.save.success')
        else
          # 処理なし
        end
       end
    rescue => e
      # 失敗
      return false, I18n.t('message.database.item_state.save.error')
    end
  end
end
