module MotionCheckConcern
  module Get
    include PageValueStateConcern::Get
    include ItemJsConcern::Get

    def motion_check_paging(user_id, user_pagevalue_id, target_pages, loaded_class_dist_tokens = [])
      gen = {}
      ins = {}
      ent = {}
      class_dist_tokens = []

      # DBから読み込み
      pages = "(#{target_pages.join(',')})"
      sql = <<-"SQL"
    SELECT gp.data as general_pagevalue_data, ip.data as instance_pagevalue_data, ep.data as event_pagevalue_data, ipp.page_num as page_num
    FROM users u
    INNER JOIN user_project_maps upm ON u.id = upm.user_id
    INNER JOIN user_pagevalues up ON upm.id = up.user_project_map_id
    LEFT JOIN general_pagevalue_pagings gpp ON up.id = gpp.user_pagevalue_id AND gpp.page_num IN #{pages} AND gpp.del_flg = 0
    LEFT JOIN general_pagevalues gp ON gpp.general_pagevalue_id = gp.id AND gp.del_flg = 0
    LEFT JOIN instance_pagevalue_pagings ipp ON up.id = ipp.user_pagevalue_id AND ipp.page_num = gpp.page_num AND ipp.del_flg = 0
    LEFT JOIN instance_pagevalues ip ON ipp.instance_pagevalue_id = ip.id AND ip.del_flg = 0
    LEFT JOIN event_pagevalue_pagings epp ON up.id = epp.user_pagevalue_id AND ipp.page_num = epp.page_num AND epp.del_flg = 0
    LEFT JOIN event_pagevalues ep ON epp.event_pagevalue_id = ep.id AND ep.del_flg = 0
    WHERE
      u.id = #{user_id.to_i}
    AND
      up.id = #{user_pagevalue_id.to_i}
    AND
      u.del_flg = 0
    AND
      upm.del_flg = 0
    AND
      up.del_flg = 0
      SQL

      ret_sql = ActiveRecord::Base.connection.select_all(sql)
      pagevalues = ret_sql.to_hash
      if pagevalues.count == 0
        return true, nil
      else
        pagevalues.each do |pagevalue|
          gen[Const::PageValueKey::P_PREFIX + pagevalue['page_num'].to_s] = JSON.parse(pagevalue['general_pagevalue_data'])
          ins[Const::PageValueKey::P_PREFIX + pagevalue['page_num'].to_s] = JSON.parse(pagevalue['instance_pagevalue_data'])
          epd = JSON.parse(pagevalue['event_pagevalue_data'])
          ent[Const::PageValueKey::P_PREFIX + pagevalue['page_num'].to_s] = epd

          # 必要なClassDistTokenを調査
          need_load_class_dist_tokens = extract_need_load_itemclassdisttokens(epd)
          class_dist_tokens = need_load_class_dist_tokens - loaded_class_dist_tokens
        end
      end

      item_js_list = get_item_gallery(class_dist_tokens)
      return true, {
          general_pagevalue: gen,
          instance_pagevalue: ins,
          event_pagevalue: ent
      }, item_js_list
    end
  end
end