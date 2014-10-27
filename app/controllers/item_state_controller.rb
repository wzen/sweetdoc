class ItemStateController < ApplicationController
  def save_itemstate
    p = {
        :user_id => params['user_id'],
        :table_id => params['table_id'],
        :item_id => params['item_id'],
        :contents => params['contents']
    }
    item_state = ItemState.new(p)
    if item_state.save
      message = t('message.database.item_state.save.success')
    else
      message = t('message.database.item_state.save.error')
    end
      @data = {
          :message => message
      }
    render :json => @data
  end

  def load_itemstate
    user_id = params['user_id']
    records = ItemState.find_by(:user_id => user_id)
    if records == null
      message = t('message.database.item_state.load.error')
    else
      message = t('message.database.item_state.load.success')
    end
    data = {
        :records => records,
        :message => message
    }
    render :json => data
  end
end
