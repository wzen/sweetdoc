json.resultSuccess @result_success
json.message @message
json.updated_at @updated_at
json.generalPagevalueData @general_pagevalue_data
json.instancePagevalueData @instance_pagevalue_data
json.eventPagevalueData @event_pagevalue_data
json.settingPagevalueData @setting_pagevalue_data
json.itemJsList @item_js_list do |itemJs|
  itemJs.each do |k, v|
    json.set!(k, v)
  end
end
