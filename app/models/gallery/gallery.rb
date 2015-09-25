class Gallery < ActiveRecord::Base
  belongs_to :user
  has_many :gallery_instance_pagevalue_pagings
  has_many :gallery_event_pagevalue_pagings
  has_many :gallery_tag_maps

  def self.save_state(user_id, tags, i_page_values, e_page_values)
    begin
      if i_page_values != 'null' && e_page_values != 'null'

        ActiveRecord::Base.transaction do
          # Gallery Insert
          g = self.new({
                           user_id: user_id
                       })
          g.save!
          gallery_id = g.id

          # Gallery InstancePageValue Insert
          i_page_values.each do |k, v|
            page_num = v['pageNum']
            pagevalue = v['pagevalue']

            ip = InstancePagevalue.new({data: pagevalue})
            ip.save!
            ipp = InstancePagevaluePaging.new({
                                                  gallery_id: gallery_id,
                                                  page_num: page_num,
                                                  instance_pagevalue_id: ip.id
                                              })
            ipp.save!
          end

          # Gallery EventPageValue Insert
          e_page_values.each do |k, v|
            page_num = v['pageNum']
            pagevalue = v['pagevalue']

            ep = EventPagevalue.new({data: pagevalue})
            ep.save!
            epp = EventPagevaluePaging.new({
                                               gallery_id: gallery_id,
                                               page_num: page_num,
                                               event_pagevalue_id: ep.id
                                           })
            epp.save!
          end

          # Save Tag
          save_tag(tags, gallery_id)

        end
      end

      return I18n.t('message.database.item_state.save.success')
    rescue => e
      # 更新失敗
      return I18n.t('message.database.item_state.save.error')
    end
  end

  # タグ名のレコードを新規作成
  def self.save_tag(tags, gallery_id)
    begin
      if tags != nil && tags.length > 0
        # タグテーブル処理
        tag_ids = []
        tags.each do |tag|
          if tag['is_new'] == nil || tag['value'] == nil
            # 例外をスロー
            raise
          end

          if tag['is_new']
            # タグを新規作成
            tag = GalleryTag.new({
                                     name: tag['value']
                                 })
            tag.save!
            tag_ids << tag.id
          else
            # タグの重み付けを加算
            tag = GalleryTag.find(tag['value'].to_i)
            tag.weight += 1
            tag.save!
            tag_ids << tag.id
          end
        end

        # タグマップテーブル作成
        tag_ids.each do |tag_id|
          map = GalleryTagMap.new({
                                      gallery_id: gallery_id,
                                      gallery_tag_id: tag_id
                                  })
        end
      end
    end

  rescue => e
    raise e
  end

  def self.get_galeries

  end

  private_class_method :save_tag
end
