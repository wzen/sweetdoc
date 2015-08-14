json.array! @item_state_list do |item_state|
  item_state.each do |k, v|
    json.set!(k, v)
  end
end
