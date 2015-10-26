require 'coding/gallery_coding'
require 'coding/user_coding'
require 'coding/user_gallery_coding_map'

class Coding
  def self.save_code(user_id, name, lang_type, code)
    begin
      ActiveRecord::Base.transaction do
        uc = UserCoding.find_by(user_id: user_id, name: name, lang_type: lang_type, del_flg: false)
        if uc == nil
          uc = UserCoding.new({
                                  user_id: user_id,
                                  name: name,
                                  lang_type: lang_type,
                                  code: code
                              })
        else
          uc.code = code
        end
        uc.save!
      end
      return I18n.t('message.database.item_state.save.success')
    rescue => e
      # 失敗
      return I18n.t('message.database.item_state.save.error')
    end
  end

  def self.load_code(user_id)
    begin
      ActiveRecord::Base.transaction do
        uc = UserCoding.where(user_id: user_id, del_flg: false)
        return uc.to_h
      end
    rescue => e
      # 失敗
      return []
    end
  end

  def self.upload(user_id, user_coding_id)
    begin
      ActiveRecord::Base.transaction do
        uc = UserCoding.find_by(id: user_coding_id, user_id: user_id, del_flg: false)
        if uc != nil
          ugcm = UserGalleryCodingMap.find_by(user_id: user_id, del_flg: false)
        else
          # データ無し
          return I18n.t('message.database.item_state.save.error')
        end
      end
    rescue => e
      # 失敗
      return I18n.t('message.database.item_state.save.error')
    end
  end

end