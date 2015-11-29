require 'item_gallery/user_item_gallery_map'
require 'coding/user_coding'

class ItemGallery < ActiveRecord::Base
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
          if update_item_gallery_id
            # 既存のUpdate
            ugcm = UserItemGalleryMap.find_by(user_id: user_id, item_gallery_id: update_item_gallery_id, del_flg: false)
            if ugcm
              # update
            else
              # データ無し
              return true, I18n.t('message.database.item_state.save.error')
            end
          else
            # Insert
            class_name = "C#{SecureRandom.hex(8)}"
            code_path = CodingHelper.
            ig = ItemGallery.new({
                                     created_user_id: user_id,
                                     class_name: class_name,

                                 })

            ugcm = UserItemGalleryMap.new({user_id: user_id,
                                          })
          end
        else
          # データ無し
          return true, I18n.t('message.database.item_state.save.error')
        end
      end
    rescue => e
    end
  end
end
