namespace :db_clean do
  desc "DB user session delete task"
  task :erase_user_session => :environment do
    begin
      ActiveRecord::Base.transaction do
        from = Time.now.advance(:minutes => -(ENV['GUEST_SESSION_EXPIRE_MINUTES']).to_i)
        p from
        guests = User.where("guest = ? AND updated_at < ?", true, from)
        if guests.present? && guests.length > 0
          guest_ids = guests.pluck(:id)
          # 削除フラグを立てる
          User.where(id: guest_ids).update_all(del_flg: true)
          upm = UserProjectMap.where(user_id: guest_ids)
          upm.update_all(del_flg: true)
          ItemImage.where(user_project_map_id: upm.pluck(:id)).update_all(del_flg: true)
          Project.where(id: upm.pluck(:project_id)).update_all(del_flg: true)
          UserCodingTree.where(user_id: guest_ids).update_all(del_flg: true)
          UserCoding.where(user_id: guest_ids).update_all(del_flg: true)
          ugfp = UserGalleryFootprintPaging.where(user_id: guest_ids)
          ugfp.update_all(del_flg: true)
          UserGalleryFootprintPagevalue.where(id: ugfp.pluck(:user_gallery_footprint_pagevalue_id)).update_all(del_flg: true)
          UserGalleryFootprint.where(user_id: guest_ids).update_all(del_flg: true)
          uigm = UserItemGalleryMap.where(user_id: guest_ids)
          uigm.update_all(del_flg: true)
          ItemGallery.where(id: uigm.pluck(:item_gallery_id)).update_all(del_flg: true)
          up = UserPagevalue.where(user_project_map_id: upm.pluck(:id))
          up.update_all(del_flg: true)
          SettingPagevalue.where(id: up.pluck(:setting_pagevalue_id)).update_all(del_flg: true)
          up_ids = up.pluck(:id)
          GeneralCommonPagevalue.where(user_pagevalue_id: up_ids).update_all(del_flg: true)
          gpp = GeneralPagevaluePaging.where(user_pagevalue_id: up_ids)
          gpp.update_all(del_flg: true)
          GeneralPagevalue.where(id: gpp.pluck(:general_pagevalue_id)).update_all(del_flg: true)
          ipp = InstancePagevaluePaging.where(user_pagevalue_id: up_ids)
          ipp.update_all(del_flg: true)
          InstancePagevalue.where(id: ipp.pluck(:instance_pagevalue_id)).update_all(del_flg: true)
          epp = EventPagevaluePaging.where(user_pagevalue_id: up_ids)
          epp.update_all(del_flg: true)
          EventPagevalue.where(id: epp.pluck(:event_pagevalue_id)).update_all(del_flg: true)
        end
      end
    rescue => e
      p e
    end
  end
end

namespace :db_clean do
  desc "DB ItemImage delete"
  task :erase_image => :environment do
    begin
      # 不要なImageのデータを削除
      ItemImage.where(user_project_map_id: Const::SAMPLE_PROJECT_USER_PROJECT_MAP_ID).update_all(del_flg: true)
    rescue => e
      p e
    end
  end
end

namespace :db_clean do
  desc "DB delete flg clean task"
  task :erase_del_flg => :environment do
    begin
      # テーブルの削除フラグtrueを消去
      EventPagevaluePaging.destroy_all(del_flg: true)
      EventPagevalue.destroy_all(del_flg: true)
      Gallery.destroy_all(del_flg: true)
      GalleryBookmarkStatistic.destroy_all(del_flg: true)
      GalleryBookmark.destroy_all(del_flg: true)
      GalleryEventPagevaluePaging.destroy_all(del_flg: true)
      GalleryEventPagevalue.destroy_all(del_flg: true)
      GalleryGeneralPagevaluePaging.destroy_all(del_flg: true)
      GalleryGeneralPagevalue.destroy_all(del_flg: true)
      GalleryInstancePagevaluePaging.destroy_all(del_flg: true)
      GalleryInstancePagevalue.destroy_all(del_flg: true)
      GalleryTagMap.destroy_all(del_flg: true)
      GalleryTag.destroy_all(del_flg: true)
      GalleryViewStatistic.destroy_all(del_flg: true)
      GeneralCommonPagevalue.destroy_all(del_flg: true)
      GeneralPagevaluePaging.destroy_all(del_flg: true)
      GeneralPagevalue.destroy_all(del_flg: true)
      InstancePagevaluePaging.destroy_all(del_flg: true)
      InstancePagevalue.destroy_all(del_flg: true)
      ItemGallery.destroy_all(del_flg: true)
      ItemGalleryTagMap.destroy_all(del_flg: true)
      ItemGalleryTag.destroy_all(del_flg: true)
      ItemGalleryUsingStatistics.destroy_all(del_flg: true)
      ItemImage.destroy_all(del_flg: true)
      ProjectGalleryMap.destroy_all(del_flg: true)
      Project.destroy_all(del_flg: true)
      SettingPagevalue.destroy_all(del_flg: true)
      UserCodingTree.destroy_all(del_flg: true)
      UserCoding.destroy_all(del_flg: true)
      UserGalleryFootprintPagevalue.destroy_all(del_flg: true)
      UserGalleryFootprintPaging.destroy_all(del_flg: true)
      UserGalleryFootprint.destroy_all(del_flg: true)
      UserItemGalleryMap.destroy_all(del_flg: true)
      UserPagevalue.destroy_all(del_flg: true)
      UserProjectMap.destroy_all(del_flg: true)
      User.destroy_all(del_flg: true)
    rescue => e
      p e
    end
  end
end
