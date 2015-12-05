require 'coding/user_coding'
require 'item_gallery/user_item_gallery_map'
require 'item_gallery/item_gallery_tag'
require 'item_gallery/item_gallery_tag_map'
require 'item_gallery/item_gallery_using_statistics'

class ItemGallery < ActiveRecord::Base
  def self.index_page_data(user_id, head = 0, limit = 30)
    begin
      # TODO: 取り方見直し 暫定で人気順
      ActiveRecord::Base.transaction do
        sql =<<-"SQL"
            SELECT
              ig.id as #{Const::ItemGallery::Key::ITEM_GALLERY_ID},
              ig.access_token as #{Const::ItemGallery::Key::ITEM_GALLERY_ACCESS_TOKEN},
              ig.title as #{Const::ItemGallery::Key::TITLE},
              ig.caption as #{Const::ItemGallery::Key::CAPTION},
              u.name as #{Const::User::Key::NAME},
              u.access_token as #{Const::User::Key::USER_ACCESS_TOKEN},
              uigm.id as #{Const::ItemGallery::Key::USER_ITEM_GALLERY_ID},
              group_concat(igt.name separator ',') as #{Const::ItemGallery::Key::TAGS}
            FROM item_galleries ig
            INNER JOIN users u ON ig.created_user_id = u.id
            LEFT JOIN item_gallery_tag_maps igtm ON igtm.item_gallery_id = ig.id AND igtm.del_flg = 0
            LEFT JOIN item_gallery_tags igt ON igtm.item_gallery_tag_id = igt.id AND igt.del_flg = 0
            LEFT JOIN item_gallery_using_statistics igus ON ig.id = igus.item_gallery_id AND igus.del_flg = 0
            LEFT JOIN user_item_gallery_maps uigm ON uigm.item_gallery_id = ig.id AND uigm.user_id = #{user_id}
            WHERE u.del_flg = 0 AND ig.del_flg = 0
            GROUP BY ig.id
            ORDER BY igus.count DESC
            LIMIT #{head}, #{limit}
        SQL
        ret_sql = ActiveRecord::Base.connection.select_all(sql)
        return ret_sql.to_hash
      end
    rescue => e
      # 失敗
      return false, I18n.t('message.database.item_state.save.error')
    end
  end

  def self.popular_tags(limit)
    begin
      # TODO: 不可対策のため統計テーブル等作る
      ActiveRecord::Base.transaction do
        sql =<<-"SQL"
            SELECT
              t.#{Const::ItemGallery::Key::TAG_ID} as #{Const::ItemGallery::Key::TAG_ID},
              t.#{Const::ItemGallery::Key::TAG_NAME} as #{Const::ItemGallery::Key::TAG_NAME},
              t.#{Const::ItemGallery::Key::ITEM_GALLERY_COUNT} as #{Const::ItemGallery::Key::ITEM_GALLERY_COUNT}
            FROM (
              SELECT
                igt.id as #{Const::ItemGallery::Key::TAG_ID},
                igt.name as #{Const::ItemGallery::Key::TAG_NAME},
                count(igtm.item_gallery_id) as #{Const::ItemGallery::Key::ITEM_GALLERY_COUNT}
              FROM item_gallery_tag_maps igtm
              INNER JOIN item_gallery_tags igt ON igtm.item_gallery_tag_id = igt.id
              WHERE igt.del_flg = 0 AND igtm.del_flg = 0
              GROUP BY igtm.item_gallery_tag_id
              LIMIT 0, #{limit} ) t
            ORDER BY t.#{Const::ItemGallery::Key::ITEM_GALLERY_COUNT} DESC

        SQL
        ret_sql = ActiveRecord::Base.connection.select_all(sql)
        return ret_sql.to_hash
      end
    rescue => e
      # 失敗
      return false, I18n.t('message.database.item_state.save.error')
    end
  end

  def self.using_items(user_id, head = 0, limit = 30)
    sql =<<-"SQL"
      SELECT
        ig.access_token as #{Const::ItemGallery::Key::ITEM_GALLERY_ACCESS_TOKEN},
        ig.title as #{Const::ItemGallery::Key::TITLE},
        ig.caption as #{Const::ItemGallery::Key::CAPTION},
        u.name as #{Const::User::Key::NAME},
        u.access_token as #{Const::User::Key::USER_ACCESS_TOKEN},
        group_concat(igt.name separator ',') as #{Const::ItemGallery::Key::TAGS}
      FROM item_galleries ig
      INNER JOIN user_item_gallery_maps uigm ON ig.id = uigm.item_gallery_id
      INNER JOIN users u ON uigm.user_id = u.id
      LEFT JOIN item_gallery_tag_maps igtm ON igtm.item_gallery_id = ig.id AND igtm.del_flg = 0
      LEFT JOIN item_gallery_tags igt ON igtm.item_gallery_tag_id = igt.id AND igt.del_flg = 0
      WHERE u.id = #{user_id}
      AND u.del_flg = 0 AND ig.del_flg = 0 AND uigm.del_flg = 0
      GROUP BY ig.id
      ORDER BY uigm.updated_at DESC
      LIMIT #{head}, #{limit}
    SQL
    ret_sql = ActiveRecord::Base.connection.select_all(sql)
    return ret_sql.to_hash
  end

  def self.created_items(user_id, head = 0, limit = 30)
    sql =<<-"SQL"
      SELECT
        t.#{Const::ItemGallery::Key::ITEM_GALLERY_ID} as #{Const::ItemGallery::Key::ITEM_GALLERY_ID},
        t.#{Const::ItemGallery::Key::ITEM_GALLERY_ACCESS_TOKEN} as #{Const::ItemGallery::Key::ITEM_GALLERY_ACCESS_TOKEN},
        t.#{Const::ItemGallery::Key::TITLE} as #{Const::ItemGallery::Key::TITLE},
        t.#{Const::ItemGallery::Key::CAPTION} as #{Const::ItemGallery::Key::CAPTION},
        t.#{Const::User::Key::NAME} as #{Const::User::Key::NAME},
        t.#{Const::User::Key::USER_ACCESS_TOKEN} as #{Const::User::Key::USER_ACCESS_TOKEN},
        t.#{Const::ItemGallery::Key::TAGS} as #{Const::ItemGallery::Key::TAGS},
        t.#{Const::ItemGallery::Key::USER_ITEM_GALLERY_ID} as #{Const::ItemGallery::Key::USER_ITEM_GALLERY_ID},
        count(uigm.id) as #{Const::User::Key::USER_COUNT}
        FROM (
        SELECT
          ig.id as #{Const::ItemGallery::Key::ITEM_GALLERY_ID},
          ig.access_token as #{Const::ItemGallery::Key::ITEM_GALLERY_ACCESS_TOKEN},
          ig.title as #{Const::ItemGallery::Key::TITLE},
          ig.caption as #{Const::ItemGallery::Key::CAPTION},
          u.name as #{Const::User::Key::NAME},
          u.access_token as #{Const::User::Key::USER_ACCESS_TOKEN},
          uigm.id as #{Const::ItemGallery::Key::USER_ITEM_GALLERY_ID},
          group_concat(igt.name separator ',') as #{Const::ItemGallery::Key::TAGS}
        FROM item_galleries ig
        INNER JOIN users u ON ig.created_user_id = u.id
        LEFT JOIN item_gallery_tag_maps igtm ON igtm.item_gallery_id = ig.id AND igtm.del_flg = 0
        LEFT JOIN item_gallery_tags igt ON igtm.item_gallery_tag_id = igt.id AND igt.del_flg = 0
        LEFT JOIN user_item_gallery_maps uigm ON uigm.item_gallery_id = ig.id AND uigm.user_id = #{user_id}
        WHERE u.id = #{user_id}
        AND u.del_flg = 0 AND ig.del_flg = 0
        AND ig.del_flg = 0
        GROUP BY ig.id
        ORDER BY ig.updated_at DESC
        LIMIT #{head}, #{limit}
      ) t
      LEFT JOIN user_item_gallery_maps uigm ON t.#{Const::ItemGallery::Key::ITEM_GALLERY_ID} = uigm.item_gallery_id AND uigm.del_flg = 0
      GROUP BY t.#{Const::ItemGallery::Key::ITEM_GALLERY_ID}
    SQL
    ret_sql = ActiveRecord::Base.connection.select_all(sql)
    return ret_sql.to_hash
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
          WHERE u.id = #{user_id}
          AND uc.del_flg = 0
          AND uc.id = #{user_coding_id}
        SQL
        ret_sql = ActiveRecord::Base.connection.select_all(sql)
        ret = ret_sql.to_hash.first
        if ret.present?
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

          if update_item_gallery_id && (ig = ItemGallery.find_by(created_user_id: user_id, item_gallery_id: update_item_gallery_id, del_flg: false)).present?
            # 既存コードのUpdate
            # update
            save_filename = ig.file_name
            user_code_path = "#{UserCodeUtil.code_parentdirpath(UserCodeUtil::CODE_TYPE::ITEM_GALLERY, user_access_token)}/#{save_filename}"
            File.open(user_code_path, 'w') do |file|
              file.write(code)
            end

            save_tag(tags, ig.id)
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

            save_tag(tags, ig.id)
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
          if t.blank?
            # タグを新規作成
            t = ItemGalleryTag.new({
                                   name: tag
                               })
            t.save!
            tag_ids << t.id

          else
            # タグの重み付けを加算
            if t.weight.present?
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
          item_gallery_id = ItemGallery.find_by(access_token: item_gallery_access_token).id
          uigm = UserItemGalleryMap.new({
                                            user_id: user_id,
                                            item_gallery_id: item_gallery_id
                                        })
          uigm.save!
          # 使用数更新
          _update_using_count(item_gallery_id)
          # 成功
          return true, I18n.t('message.database.item_state.save.success')
        elsif ret.count > 0 && !is_add
          # 削除処理
          uigm = UserItemGalleryMap.find(ret.first['user_item_gallery_id'])
          uigm.destroy!
          # 使用数更新
          _update_using_count(ret.first['item_gallery_id'])
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

  def self._update_using_count(item_gallery_id)
    count = UserItemGalleryMap.where(item_gallery_id: item_gallery_id).count
    # 使用数更新
    igus = ItemGalleryUsingStatistics.find(item_gallery_id: item_gallery_id)
    if igus.present?
      # Update
      igus.count = count
    else
      # Insert
      igus = ItemGalleryUsingStatistics.new({
                                         item_gallery_id: item_gallery_id,
                                         count: count
                                      })
    end
    igus.save!
  end

  private_class_method :_update_using_count
end
