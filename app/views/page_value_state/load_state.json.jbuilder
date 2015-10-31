json.resultSuccess @result_success
json.message @message
json.updated_at @updated_at
json.project_pagevalue_data @project_pagevalue_data
json.general_pagevalue_data @general_pagevalue_data
json.instance_pagevalue_data @instance_pagevalue_data
json.event_pagevalue_data @event_pagevalue_data
json.setting_pagevalue_data @setting_pagevalue_data
json.itemJsList @item_js_list do |itemJs|
  itemJs.each do |k, v|
    json.set!(k, v)
  end
end
