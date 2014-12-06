require 'const'

class ItemStateController < ApplicationController
  def save_itemstate
    p = {
        :user_id => params['user_id'],
        :state => params['state']
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
    loaded_item_type_list = JSON.parse(params['loaded_item_type_list'])
    render :json => ItemState.new.get_js_list_json(user_id, loaded_item_type_list)
  end
end
