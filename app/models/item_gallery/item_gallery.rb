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

          if update_item_gallery_id && (ugcm = UserItemGalleryMap.find_by(user_id: user_id, item_gallery_id: update_item_gallery_id, del_flg: false))
            # 既存コードのUpdate
            # update
            ig = ItemGallery.find(ugcm.item_gallery_id)
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

            # Insert
            ig = ItemGallery.new({
                                     created_user_id: user_id,
                                     class_name: class_name,
                                     public_type: Const::ItemGallery::PublicType::PUBLIC,
                                     file_name: save_filename
                                 })
            ig_id = ig.save!
            ugcm = UserItemGalleryMap.new({user_id: user_id,
                                           item_gallery_id: ig_id
                                          })
            ugcm.save!
          end
          # 成功
          return true, I18n.t('message.database.item_state.save.success')
        else
          # データ無し
          return false, I18n.t('message.database.item_state.save.error')
        end
      end
    rescue => e
    end
  end
end
