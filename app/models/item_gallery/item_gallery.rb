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
        uc = UserCoding.find_by(id: user_coding_id, user_id: user_id, del_flg: false)
        if uc != nil
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
