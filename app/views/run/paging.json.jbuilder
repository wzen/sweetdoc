json.resultSuccess @result_success
json.pagevalues @pagevalues
json.itemJsList @item_js_list do |itemJs|
  itemJs.each do |k, v|
    json.set!(k, v)
  end
end