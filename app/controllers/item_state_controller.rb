require 'const'

class ItemStateController < ApplicationController
  def save_itemstate
    p = {
        :user_id => params['user_id'],
        :contents => params['contents']
    }
    item_state = ItemState.new(p)
    if item_state.save
      message = t('message.database.item_state.save.success')
    else
      message = t('message.database.item_state.save.error')
    end
      data = {
          :message => message
      }
    render :json => data
  end

  def load_itemstate
    user_id = params['user_id']
    loaded_js_path_list = params['loaded_js_path_list']
    item_state = ItemState.find_by(:user_id => user_id)
    item_js_list = []
    if item_state == nil
      message = t('message.database.item_state.load.error')
    else
      message = t('message.database.item_state.load.success')
      item_list = JSON.parse(item_state.contents)
      item_list.each do |item|
        it = item['obj']['itemType']
        js_path = Const::ITEM_PATH_LIST[it.to_s.to_sym]
        unless loaded_js_path_list.include?(js_path)
          item_js_list.push({:item_type => it, :src => ItemJsController.get_lack_js(js_path)})
        end
      end
    end
    data = {
        :item_state => item_state.to_json,
        :js_list => item_js_list.to_json,
        :message => message
    }
    render :json => data
  end
end
