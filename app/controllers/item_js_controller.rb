class ItemJsController < ApplicationController

  def index
    item_ids = params['itemIds']
    item_action_events_all = ItemJs.find_events_by_itemid(item_ids)
    return if item_action_events_all.length == 0

    @indexes = ItemJs.extract_iae(item_action_events_all)
  end

  def timeline_config(te_action)
    @class_name = Const::ElementAttribute::ITEM_VALUES_CLASS
                      .sub(/@itemid/, te_action[:item_id].to_s)
                      .sub(/@methodname/, te_action[:method_name])
    options = te_action.options
    @args = te_action.options['args']
    render_to_string :action => 'timeline_config', :layout => false
  end

end
