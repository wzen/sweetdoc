json.set!('message', @message)
json.set!('instance_pagevalue_data', @instance_pagevalue_data)
json.set!('event_pagevalue_data', @event_pagevalue_data)
json.set!('setting_pagevalue_data', @setting_pagevalue_data)
json.array! @item_js_list do |itemJs|
  itemJs.each do |k, v|
    json.set!(k, v)
  end
end
