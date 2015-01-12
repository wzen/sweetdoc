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
# @param [Boolean] withRemove 取得後に値を消去するか
# @return [Object] ハッシュ配列または値で返す
getPageValue = (key, withRemove = false) ->
  f = @
  # div以下の値をハッシュとしてまとめる
  takeValue = (element) ->
    ret = []
    c = $(element).children()
    if c? && c.length > 0
      $(c).each((e) ->
        v = null
        if @.tagName == "INPUT"
          v = $(@).val()
        else
          v = takeValue.call(f, @)
        ret[@.classList[0]] = v
      )
    return ret

  value = null
  root = $('#page_values')
  keys = key.split(Constant.PAGE_VALUES_SEPERATOR)
  keys.forEach((k, index) ->
    root = $(".#{k}", root)
    if !root? || root.length == 0
      value = null
      return
    if keys.length - 1 == index
      if root[0].tagName == "INPUT"
        value = root.val()
      else
        value = takeValue.call(f,root)
      if withRemove
        root.remove()
  )
  return value

# ページが持つ値を設定
# @param [String] key キー値
# @param [Object] value 設定値(ハッシュ配列または値)
# @param [Boolean] isCache このページでのみ保持する値か
setPageValue = (key, value, isCache = false) ->
  f = @
  # ハッシュを要素の文字列に変換
  makeElementStr = (ky, val) ->
    if jQuery.type(val) != "object"
      return "<input type='hidden' class=#{ky} value=#{val} />"

    ret = ""
    for k, v of val
      ret += makeElementStr.call(f, k, v)
    return "<div class=#{ky}>#{ret}</div>"

  cacheClassName = 'cache'
  root = $('#page_values')
  keys = key.split(Constant.PAGE_VALUES_SEPERATOR)
  keys.forEach((k, index) ->
    parent = root
    element = ''
    if keys.length - 1 > index
      element = 'div'
    else
      if jQuery.type(value) == "object"
        element = 'div'
      else
        element = 'input'
    root = $("#{element}.#{k}", parent)
    if keys.length - 1 > index
      if !root? || root.length == 0
        # 親要素のdiv作成
        root = jQuery("<div class=#{k}></div>").appendTo(parent)
    else
      if root? && root.length > 0
        # 要素が存在する場合は消去して上書き
        root.remove()
      # 要素作成
      root = jQuery(makeElementStr.call(f, k, value)).appendTo(parent)
      if isCache
        root.addClass(cacheClassName)
  )

# 画面共通の初期化処理 ajaxでサーバから読み込む等
do ->
  window.loadedItemTypeList = []

$ ->
  window.drawingCanvas = document.getElementById('canvas_container')
  window.drawingContext = drawingCanvas.getContext('2d')