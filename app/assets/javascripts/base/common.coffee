# ブラウザ対応のチェック
# @return [Boolean] 処理結果
checkBlowserEnvironment = ->
  if !localStorage
    return false
  else
    try
      localStorage.setItem('test', 'test')
      c = localStorage.getItem('test')
      localStorage.removeItem('test')
    catch e
      return false
  if !File
    return false
  return true

# アイテムのIDを作成
# @return [Int] 生成したID
generateId = ->
  numb = 10 #10文字
  RandomString = '';
  BaseString ='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
  n = 62
  for i in [0..numb]
    RandomString += BaseString.charAt( Math.floor( Math.random() * n))
  return RandomString

# オブジェクトの複製
# @param [Object] obj 複製対象オブジェクト
# @return [Object] 複製後オブジェクト
makeClone = (obj) ->
  if not obj? or typeof obj isnt 'object'
    return obj
  if obj instanceof Date
    return new Date(obj.getTime())
  if obj instanceof RegExp
    flags = ''
    flags += 'g' if obj.global?
    flags += 'i' if obj.ignoreCase?
    flags += 'm' if obj.multiline?
    flags += 'y' if obj.sticky?
    return new RegExp(obj.source, flags)
  newInstance = new obj.constructor()
  for key of obj
    newInstance[key] = clone obj[key]
  return newInstance

# 画面共通の初期化処理 ajaxでサーバから読み込む等
do ->
  window.loadedItemTypeList = []

$ ->
  window.drawingCanvas = document.getElementById('canvas_container')
  window.drawingContext = drawingCanvas.getContext('2d')