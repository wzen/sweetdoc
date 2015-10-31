json.resultSuccess @result_success
json.array! @user_pagevalue_list do |p|
  json.id p['id']
  json.project_title p['project_title']
  json.updated_at p['updated_at']
end
