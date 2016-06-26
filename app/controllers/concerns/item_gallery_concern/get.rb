module ItemGalleryConcern
  module Get
    def item_gallery_index_page_data(user_id, head = 0, limit = 30)
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
            LEFT JOIN user_item_gallery_maps uigm ON uigm.item_gallery_id = ig.id AND uigm.user_id = #{user_id.to_i}
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

    def item_gallery_popular_tags(limit)
      begin
        # TODO: 負荷対策のため統計テーブル等作る
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

    def using_item_galleries(user_id, head = 0, limit = 30)
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
      WHERE u.id = #{user_id.to_i}
      AND u.del_flg = 0 AND ig.del_flg = 0 AND uigm.del_flg = 0
      GROUP BY ig.id
      ORDER BY uigm.updated_at DESC
      LIMIT #{head}, #{limit}
      SQL
      ret_sql = ActiveRecord::Base.connection.select_all(sql)
      return ret_sql.to_hash
    end

    def created_item_galleries(user_id, head = 0, limit = 30)
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
        LEFT JOIN user_item_gallery_maps uigm ON uigm.item_gallery_id = ig.id AND uigm.user_id = #{user_id.to_i}
        WHERE u.id = #{user_id.to_i}
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

    def code_filepath(item_gallery_access_token)
      begin
        ActiveRecord::Base.transaction do
          sql =<<-"SQL"
          SELECT u.access_token as created_user_access_token, ig.file_name as code_filename, ig.class_name as item_class_name
          FROM users u INNER JOIN item_galleries ig ON u.id = ig.created_user_id
          WHERE ig.access_token = #{ActiveRecord::Base.connection.quote(item_gallery_access_token)}
          AND u.del_flg = 0
          AND ig.del_flg = 0
          SQL
          ret_sql = ActiveRecord::Base.connection.select_all(sql)
          r = ret_sql.to_hash
          if r.count > 0
            return UserCodeUtil.code_urlpath(UserCodeUtil::CODE_TYPE::ITEM_GALLERY, r.first['created_user_access_token'], r.first['code_filename']), r.first['item_class_name']
          else
            return nil, nil
          end
        end
      rescue => e
        # 失敗
        return nil, nil
      end
    end
  end
end