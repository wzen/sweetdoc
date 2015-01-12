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

# ページが持つ値を取得
# @param [String] key キー値
# @return [Object] ハッシュ配列または値で返す
getPageValue = (key) ->
  value = null
  root = $('#page_values')
  keys = key.split(Constant.PAGE_VALUES_SEPERATOR)
  keys.forEach((k, index) ->
    element = ''
    if keys.length - 1 > index
      element = 'div'
    else
      element = 'input'
    root = $("#{element}.#{k}", root)
    if !root? || root.length == 0
      value = null
      return
    if keys.length - 1 == index
      value = root.val()
  )
  return value

# ページが持つ値を設定
# @param [String] key キー値
# @param [Object] value 設定値(ハッシュ配列または値)
# @param [Boolean] isCache このページでのみ保持する値か
setPageValue = (key, value, isCache = false) ->
  cacheClassName = 'cache'
  root = $('#page_values')
  keys = key.split(Constant.PAGE_VALUES_SEPERATOR)
  keys.forEach((k, index) ->
    parent = root
    element = ''
    if keys.length - 1 > index
      element = 'div'
    else
      element = 'input'
    root = $("#{element}.#{k}", parent)
    if keys.length - 1 > index
      if !root? || root.length == 0
        # div作成
        root = jQuery("<div class=#{k}></div>").appendTo(parent)
    else
      if !root? || root.length == 0
        # input作成
        root = jQuery("<input type='hidden' value=#{value}></div>").appendTo(parent)
        root.addClass(k)
        if isCache
          root.addClass(cacheClassName)
      else
        # 値を上書き
        root.val(value)
        if isCache
          root.addClass(cacheClassName)
        else
          root.removeClass(cacheClassName)
  )

# 画面共通の初期化処理 ajaxでサーバから読み込む等
do ->
  window.loadedItemTypeList = []

$ ->
  window.drawingCanvas = document.getElementById('canvas_container')
  window.drawingContext = drawingCanvas.getContext('2d')