json.resultSuccess @result_success
json.user_pagevalue_list @user_pagevalue_list do |p|
  json.id p['id']
  json.updated_at p['updated_at']
end
