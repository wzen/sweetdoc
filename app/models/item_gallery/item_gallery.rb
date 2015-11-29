require 'item_gallery/user_item_gallery_map'
require 'coding/user_coding'

class ItemGallery < ActiveRecord::Base
  def self.save_state(
      user_id,
      user_coding_id,
      tags,
      title,
      caption
  )
    begin
      ActiveRecord::Base.transaction do
        uc = UserCoding.find_by(id: user_coding_id, user_id: user_id, del_flg: false)
        if uc != nil
          ugcm = UserItemGalleryMap.find_by(user_id: user_id, del_flg: false)
        else
          # データ無し
          return true, I18n.t('message.database.item_state.save.error')
        end
      end
    rescue => e
    end
  end
end
