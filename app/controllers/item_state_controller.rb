require 'const'

class ItemStateController < ApplicationController
  def save_itemstate
    p = {
        :user_id => params['user_id'],
        :state => params['state'],
        :css_info => params['css']
    }
    item_state = ItemState.new(p)
    if item_state.save
      @message = t('message.database.item_state.save.success')
    else
      @message = t('message.database.item_state.save.error')
    end
  end

  def load_itemstate
    user_id = params['user_id']
    loaded_itemids = JSON.parse(params['loaded_itemids'])
    @item_state_list = ItemJs.get_user_iae_infos(user_id, loaded_itemids)
  end
end
