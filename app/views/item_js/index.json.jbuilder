json.resultSuccess @result_success
json.array! @indexes do |index|
  index.each do |k, v|
    json.set!(k, v)
  end
end
