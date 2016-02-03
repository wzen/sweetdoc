namespace :db_clean do
  desc "DB clean task"
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
      logger.error e
    end
  end
  task :erase_del_flg => :environment do
    begin
      from = Time.advance(:minutes => -(Env['SESSION_EXPIRE_MINUTES']).to_i)
      to = Time.now
      guest_ids = User.where({guest: true, updated_at: from...to})
      if guest_ids.present? && guest_ids.length > 0
        p guest_ids
        # 削除フラグを立てる
      end
    rescue => e
      logger.error e
    end
  end
end
