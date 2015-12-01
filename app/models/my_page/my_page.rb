require 'gallery/gallery'
require 'item_gallery/item_gallery'

class MyPage
  def self.created_contents(user_id)
    sql <<-"SQL"
      SELECT g.*
      FROM user_project_maps upm
      INNER JOIN users u ON upm.user_id = u.id
      INNER JOIN project_gallery_maps pgm ON pgm.user_project_map_id = pgm.id
      INNER JOIN galleries g ON g.id = pgm.gallery_id
      WHERE u.id = #{user_id}
      AND u.del_flg = 0 AND pgm.del_flg = 0 AND upm.del_flg = 0 AND g.del_flg = 0
      ORDER BY g.updated_at DESC
    SQL
    ret_sql = ActiveRecord::Base.connection.select_all(sql)
    return ret_sql.to_hash
  end

  def self.created_items(user_id)
    sql <<-"SQL"
      SELECT ig.*
      FROM item_galleries ig
      INNER JOIN users u ON ig.created_user_id = u.id
      WHERE u.id = #{user_id}
      AND u.del_flg = 0 AND ig.del_flg = 0
      ORDER BY ig.updated_at DESC
    SQL
    ret_sql = ActiveRecord::Base.connection.select_all(sql)
    return ret_sql.to_hash
  end

  def self.bookmarks(user_id)
    sql <<-"SQL"
      SELECT g.*
      FROM gallery_bookmarks gb
      INNER JOIN users u ON gb.user_id = u.id
      INNER JOIN galleries g ON g.id = gb.gallery_id
      WHERE u.id = #{user_id}
      AND u.del_flg = 0 AND gb.del_flg = 0 AND g.del_flg = 0
      ORDER BY gb.updated_at DESC
    SQL
    ret_sql = ActiveRecord::Base.connection.select_all(sql)
    return ret_sql.to_hash
  end

  def self.using_items(user_id)
    sql <<-"SQL"
      SELECT ig.*
      FROM item_galleries ig
      INNER JOIN user_item_gallery_maps uigm ON ig.id = uigm.item_gallery_id
      INNER JOIN users u ON uigm.user_id = u.id
      WHERE u.id = #{user_id}
      AND u.del_flg = 0 AND ig.del_flg = 0 AND uigm.del_flg = 0
      ORDER BY uigm.updated_at DESC
    SQL
    ret_sql = ActiveRecord::Base.connection.select_all(sql)
    return ret_sql.to_hash
  end
end