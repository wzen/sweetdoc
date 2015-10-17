require 'item/item'
require 'item/item_js'

class MotionCheck
  def self.paging(user_id, project_id, target_pages, loaded_itemids = [])
    ins = {}
    ent = {}
    itemids = []
    general = Rails.cache.read("user_id:#{user_id}-general")
    instance = Rails.cache.read("user_id:#{user_id}-instance")
    event = Rails.cache.read("user_id:#{user_id}-event")
    if general == nil || instance == nil || event == nil
      # DBから読み込み
      pages = "(#{target_pages.join(',')})"
      sql = <<-"SQL"
      SELECT gp.data as general_pagevalue_data, ip.data as instance_pagevalue_data, ep.data as event_pagevalue_data, ipp.page_num as page_num
      FROM users u
      INNER JOIN user_project_maps upm ON u.id = upm.user_id
      INNER JOIN projects p ON upm.project_id = p.id
      LEFT JOIN general_pagevalue_pagings gpp ON up.id = gpp.user_pagevalue_id AND gpp.page_num IN #{pages} AND gpp.del_flg = 0
      LEFT JOIN general_pagevalues gp ON gpp.general_pagevalue_id = gp.id AND gp.del_flg = 0
      LEFT JOIN instance_pagevalue_pagings ipp ON up.id = ipp.user_pagevalue_id AND ipp.page_num = gpp.page_num AND ipp.del_flg = 0
      LEFT JOIN instance_pagevalues ip ON ipp.instance_pagevalue_id = ip.id AND ip.del_flg = 0
      LEFT JOIN event_pagevalue_pagings epp ON up.id = epp.user_pagevalue_id AND ipp.page_num = epp.page_num AND epp.del_flg = 0
      LEFT JOIN event_pagevalues ep ON epp.event_pagevalue_id = ep.id AND ep.del_flg = 0
      WHERE
        u.id = #{user_id}
      AND
        p.id = #{project_id}
      AND
        u.del_flg = 0
      AND
        upm.del_flg = 0
      AND
        p.del_flg = 0
      SQL

      ret_sql = ActiveRecord::Base.connection.select_all(sql)
      pagevalues = ret_sql.to_hash
      if pagevalues.count == 0
        return nil
      else
        gen = {}
        ins = {}
        ent = {}
        pagevalues.each do |pagevalue|
          gen[Const::PageValueKey::P_PREFIX + pagevalue['page_num']] = pagevalue['general_pagevalue_data']
          ins[Const::PageValueKey::P_PREFIX + pagevalue['page_num']] = pagevalue['instance_pagevalue_data']
          epd = pagevalue['event_pagevalue_data']
          ent[Const::PageValueKey::P_PREFIX + pagevalue['page_num']] = epd

          # 必要なItemIdを調査
          epd.each do |kk, vv|
            if kk.index(Const::PageValueKey::E_MASTER_ROOT) || kk.index(Const::PageValueKey::EF_PREFIX)
              vv.each do |k, v|
                if k.index(Const::PageValueKey::E_NUM_PREFIX) != nil
                  item_id = v[Const::EventPageValueKey::ITEM_ID]
                  unless loaded_itemids.include?(item_id)
                    if item_id != nil
                      itemids << item_id
                    end
                  end
                end
              end
            end
          end


          # JSON.parse(epd).each do |k, v|
          #   if k.index(Const::PageValueKey::E_NUM_PREFIX) != nil
          #     item_id = v[Const::EventPageValueKey::ITEM_ID]
          #     unless loaded_itemids.include?(item_id)
          #       if item_id != nil
          #         itemids << item_id
          #       end
          #     end
          #   end
          # end
        end
      end

    else
      # cacheから読み込み
      for i in target_pages
        ins[Const::PageValueKey::P_PREFIX + i] = instance[Const::PageValueKey::P_PREFIX + i]
        epd = event[Const::PageValueKey::P_PREFIX + i]
        ent[Const::PageValueKey::P_PREFIX + i] = epd
        # 必要なItemIdを調査
        epd.each do |kk, vv|
          if kk.index(Const::PageValueKey::E_MASTER_ROOT) || kk.index(Const::PageValueKey::EF_PREFIX)
            vv.each do |k, v|
              if k.index(Const::PageValueKey::E_NUM_PREFIX) != nil
                item_id = v[Const::EventPageValueKey::ITEM_ID]
                unless loaded_itemids.include?(item_id)
                  if item_id != nil
                    itemids << item_id
                  end
                end
              end
            end
          end
        end
      end
    end

    item_js_list = ItemJs.extract_iteminfo(Item.find(itemids))
    return {
        general_pagevalue: gen,
        instance_pagevalue: ins,
        event_pagevalue: ent
    }, item_js_list
  end
end