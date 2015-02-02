class ItemJsController < ApplicationController

  def index
    item_id = params['itemId']
    item_action_events = ItemJs.item_contents(item_id)
    return if item_action_events.length == 0

    @index = ItemJs.suitable_data(item_action_events)
  end

  def timeline_config(te_action)
    @class_name = Const::ElementAttribute::TE_VALUES_CLASS
                      .sub(/@itemid/, te_action[:item_id].to_s)
                      .sub(/@methodname/, te_action[:method_name])
    @type = te_action.options['type']
    render_to_string :action => 'timeline_config', :layout => false
  end

end
