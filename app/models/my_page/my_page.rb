require 'gallery/gallery'
require 'item_gallery/item_gallery'

class MyPage
  def self.created_contents(user_id)
    sql =<<-"SQL"
      SELECT
        g.access_token as #{Const::Gallery::Key::GALLERY_ACCESS_TOKEN},
        g.title as #{Const::Gallery::Key::TITLE},
        g.caption as #{Const::Gallery::Key::CAPTION},
        g.thumbnail_img_width as #{Const::Gallery::Key::THUMBNAIL_IMG_WIDTH},
        g.thumbnail_img_height as #{Const::Gallery::Key::THUMBNAIL_IMG_HEIGHT},
        g.screen_width as #{Const::Gallery::Key::SCREEN_SIZE_WIDTH},
        g.screen_height as #{Const::Gallery::Key::SCREEN_SIZE_HEIGHT},
        u.name as #{Const::User::Key::NAME},
        group_concat(gt.name separator ',') as #{Const::Gallery::Key::TAGS}
      FROM user_project_maps upm
      INNER JOIN users u ON upm.user_id = u.id
      INNER JOIN project_gallery_maps pgm ON pgm.user_project_map_id = pgm.id
      INNER JOIN galleries g ON g.id = pgm.gallery_id
      INNER JOIN gallery_tag_maps gtm ON gtm.gallery_id = g.id
      INNER JOIN gallery_tags gt ON gtm.gallery_tag_id = gt.id
      WHERE u.id = #{user_id}
      AND u.del_flg = 0 AND pgm.del_flg = 0 AND upm.del_flg = 0 AND g.del_flg = 0
      AND gtm.del_flg = 0 AND gt.del_flg = 0
      GROUP BY g.id
      ORDER BY g.updated_at DESC
    SQL
    ret_sql = ActiveRecord::Base.connection.select_all(sql)
    return ret_sql.to_hash
  end

  def self.created_items(user_id)
    sql =<<-"SQL"
      SELECT
        t.#{Const::ItemGallery::Key::ITEM_GALLERY_ID} as #{Const::ItemGallery::Key::ITEM_GALLERY_ID},
        t.#{Const::ItemGallery::Key::ITEM_GALLERY_ACCESS_TOKEN} as #{Const::ItemGallery::Key::ITEM_GALLERY_ACCESS_TOKEN},
        t.#{Const::ItemGallery::Key::TITLE} as #{Const::ItemGallery::Key::TITLE},
        t.#{Const::ItemGallery::Key::CAPTION} as #{Const::ItemGallery::Key::CAPTION},
        t.#{Const::User::Key::NAME} as #{Const::User::Key::NAME},
        t.#{Const::ItemGallery::Key::TAGS} as #{Const::ItemGallery::Key::TAGS},
        count(*) as #{Const::User::Key::USER_COUNT}
　　　 FROM (
        SELECT
          ig.id as #{Const::ItemGallery::Key::ITEM_GALLERY_ID},
          ig.access_token as #{Const::ItemGallery::Key::ITEM_GALLERY_ACCESS_TOKEN},
          ig.title as #{Const::ItemGallery::Key::TITLE},
          ig.caption as #{Const::ItemGallery::Key::CAPTION},
          u.name as #{Const::User::Key::NAME},
          group_concat(igt.name separator ',') as #{Const::ItemGallery::Key::TAGS}
        FROM item_galleries ig
        INNER JOIN users u ON ig.created_user_id = u.id
        INNER JOIN item_gallery_tag_maps igtm ON igtm.gallery_id = ig.id
        INNER JOIN item_gallery_tags igt ON igtm.gallery_tag_id = igt.id
        WHERE u.id = #{user_id}
        AND u.del_flg = 0 AND ig.del_flg = 0
        AND ig.del_flg = 0 AND igt.del_flg = 0
        GROUP BY ig.id
        ORDER BY ig.updated_at DESC
      ) t
      LEFT JOIN user_item_gallery_maps uigm ON t.#{Const::ItemGallery::Key::ITEM_GALLERY_ID} = uigm.item_gallery_id AND uigm.del_flg = 0
      GROUP BY t.#{Const::ItemGallery::Key::ITEM_GALLERY_ID}
    SQL
    ret_sql = ActiveRecord::Base.connection.select_all(sql)
    return ret_sql.to_hash
  end

  def self.bookmarks(user_id)
    sql =<<-"SQL"
      SELECT
        g.access_token as #{Const::Gallery::Key::GALLERY_ACCESS_TOKEN},
        g.title as #{Const::Gallery::Key::TITLE},
        g.caption as #{Const::Gallery::Key::CAPTION},
        g.thumbnail_img_width as #{Const::Gallery::Key::THUMBNAIL_IMG_WIDTH},
        g.thumbnail_img_height as #{Const::Gallery::Key::THUMBNAIL_IMG_HEIGHT},
        g.screen_width as #{Const::Gallery::Key::SCREEN_SIZE_WIDTH},
        g.screen_height as #{Const::Gallery::Key::SCREEN_SIZE_HEIGHT},
        u.name as #{Const::User::Key::NAME},
        group_concat(gt.name separator ',') as #{Const::Gallery::Key::TAGS}
      FROM gallery_bookmarks gb
      INNER JOIN users u ON gb.user_id = u.id
      INNER JOIN galleries g ON g.id = gb.gallery_id
      WHERE u.id = #{user_id}
      AND u.del_flg = 0 AND gb.del_flg = 0 AND g.del_flg = 0
      AND gtm.del_flg = 0 AND gt.del_flg = 0
      GROUP BY g.id
      ORDER BY gb.updated_at DESC
    SQL
    ret_sql = ActiveRecord::Base.connection.select_all(sql)
    return ret_sql.to_hash
  end

  def self.using_items(user_id)
    sql =<<-"SQL"
      SELECT
        ig.access_token as #{Const::ItemGallery::Key::ITEM_GALLERY_ACCESS_TOKEN},
        ig.title as #{Const::ItemGallery::Key::TITLE},
        ig.caption as #{Const::ItemGallery::Key::CAPTION},
        u.name as #{Const::User::Key::NAME},
        group_concat(igt.name separator ',') as #{Const::ItemGallery::Key::TAGS}
      FROM item_galleries ig
      INNER JOIN user_item_gallery_maps uigm ON ig.id = uigm.item_gallery_id
      INNER JOIN users u ON uigm.user_id = u.id
      INNER JOIN item_gallery_tag_maps igtm ON igtm.gallery_id = ig.id
      INNER JOIN item_gallery_tags igt ON igtm.gallery_tag_id = igt.id
      WHERE u.id = #{user_id}
      AND u.del_flg = 0 AND ig.del_flg = 0 AND uigm.del_flg = 0
      AND ig.del_flg = 0 AND igt.del_flg = 0
      GROUP BY ig.id
      ORDER BY uigm.updated_at DESC
    SQL
    ret_sql = ActiveRecord::Base.connection.select_all(sql)
    return ret_sql.to_hash
  end
end