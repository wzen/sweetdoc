class ItemJsController < ApplicationController

  def index
    item_id = params['itemId']
    item_action_events = ItemJs.find_events_by_itemid(item_id)
    return if item_action_events.length == 0

    @index = ItemJs.extract_iae(item_action_events)
    @index[:item_id] = item_id
  end

  def timeline_config(te_action)
    @class_name = Const::ElementAttribute::TE_VALUES_CLASS
                      .sub(/@itemid/, te_action[:item_id].to_s)
                      .sub(/@methodname/, te_action[:method_name])
    @args = te_action.options['args']
    render_to_string :action => 'timeline_config', :layout => false
  end

end
