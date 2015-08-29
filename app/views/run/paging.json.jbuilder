json.instance_pagevalue_hash @instance_pagevalue_hash do |h|
  h.each do |k, v|
    json.set!(k, v)
  end
end
json.event_pagevalue_hash @event_pagevalue_hash do |h|
  h.each do |k, v|
    json.set!(k, v)
  end
end

