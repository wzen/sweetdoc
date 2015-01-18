require 'I18n'

class ItemState < ActiveRecord::Base
  def get_item_info_list(user_id, loaded_item_type_list)
    result = ItemState.where(:user_id => user_id).order(id: :desc).first
    item_js_list = []
    if result == nil
      message = I18n.t('message.database.item_state.load.error')
    else
      message = I18n.t('message.database.item_state.load.success')
      item_list = JSON.parse(result.state)
      item_type_list = []
      item_list.each do |item|
        item_type = item['obj']['itemType']
        unless loaded_item_type_list.include?(item_type)
          item_type_list << item_type
        end
      end

      # 必要なCSSテンプレートを読み込み
      if item_type_list.size > 0
        item_css_temps = ItemCssTemp.where(item_id: item_type_list).order(item_type: :asc)
        item_type_list.sort.each do |item_type|
          css_temp = item_css_temps.find_by(:item_type => item_type)
          if css_temp != nil
            css_temp_contents = css_temp.contents
          end
          item_js_list << {:item_type => item_type, :src => ItemJs.new.get_lack_js(item_type), :css_temp => css_temp_contents}
        end
      end
      if result.css_info != nil
        css_info_list = JSON.parse(result.css_info)
      end
    end
    data = {
        :item_list => item_list.to_json,
        :js_list => item_js_list.to_json,
        :css_info_list => css_info_list,
        :message => message
    }
    return data
  end

end
