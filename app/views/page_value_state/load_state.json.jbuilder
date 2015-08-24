json.message @message
json.instance_pagevalue_data @instance_pagevalue_data
json.event_pagevalue_data @event_pagevalue_data
json.setting_pagevalue_data @setting_pagevalue_data
json.item_js_list @item_js_list do |itemJs|
  itemJs.each do |k, v|
    json.set!(k, v)
  end
end
