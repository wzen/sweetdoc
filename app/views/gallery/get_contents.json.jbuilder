json.contents @contents do |content|
  content.each do |k, v|
    json.set!(k, v)
  end
end