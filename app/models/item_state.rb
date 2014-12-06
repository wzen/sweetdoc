require 'I18n'

class ItemState < ActiveRecord::Base
  def get_js_list_json(user_id, loaded_item_type_list)
    result = ItemState.find_by(:user_id => user_id)
    item_js_list = []
    if result == nil
      message = I18n.t('message.database.item_state.load.error')
    else
      message = I18n.t('message.database.item_state.load.success')
      item_list = JSON.parse(result.state)
      item_list.each do |item|
        it = item['obj']['itemType']
        unless loaded_item_type_list.include?(it)
          item_js_list.push({:item_type => it, :src => ItemJs.new.get_lack_js(it)})
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
