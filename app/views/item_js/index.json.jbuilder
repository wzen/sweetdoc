json.resultSuccess @result_success
json.indexes @indexes do |index|
  index.each do |k, v|
    json.set!(k, v)
  end
end
