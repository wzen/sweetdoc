require 'I18n'

class ItemState < ActiveRecord::Base
  def get_js_list_json(user_id, loaded_js_path_list)
    item_state = ItemState.find_by(:user_id => user_id)
    item_js_list = []
    if item_state == nil
      message = I18n.t('message.database.item_state.load.error')
    else
      message = I18n.t('message.database.item_state.load.success')
      item_list = JSON.parse(item_state.contents)
      item_list.each do |item|
        it = item['obj']['itemType']
        js_path = Const::ITEM_PATH_LIST[it.to_s.to_sym]
        unless loaded_js_path_list.include?(js_path)
          item_js_list.push({:item_type => it, :src => ItemJs.new.get_lack_js(js_path)})
        end
      end
    end
    data = {
        :item_state => item_state.to_json,
        :js_list => item_js_list.to_json,
        :message => message
    }
    return data
  end

end
