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

typeOfValue = do ->
  classToType = {}
  for name in "Boolean Number String Function Array Date RegExp Undefined Null".split(" ")
    classToType["[object " + name + "]"] = name.toLowerCase()
  (obj) ->
    strType = Object::toString.call(obj)
    classToType[strType] or "object"

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

# アイテムに対してフォーカスする
# @param [Object] target 対象アイテム
focusToTarget = (target) ->
  # col-md-9 → 75% padding → 15px
  targetMiddle =
    top: $(target).offset().top + $(target).height() * 0.5
    left: $(target).offset().left + $(target).width() * 0.5
  scrollTop = targetMiddle.top - scrollContents.height() * 0.5
  if scrollTop < 0
    scrollTop = 0
  else if scrollTop > scrollContents.height() * 0.25
    scrollTop =  scrollContents.height() * 0.25
  scrollLeft = targetMiddle.left - scrollContents.width() * 0.75 * 0.5
  if scrollLeft < 0
    scrollLeft = 0
  else if scrollLeft > scrollContents.width() * 0.25
    scrollLeft =  scrollContents.width() * 0.25
  # スライド
  #console.log("focusToTarget:: scrollTop:#{scrollTop} scrollLeft:#{scrollLeft}")
  scrollContents.animate({scrollTop: (scrollContents.scrollTop() + scrollTop), scrollLeft: (scrollContents.scrollLeft() + scrollLeft) }, 500)


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
          # サニタイズをデコード
          v = sanitaizeDecode($(@).val())
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
        value = sanitaizeDecode(root.val())
      else
        value = takeValue.call(f,root)
      if withRemove
        root.remove()
  )
  return value

# ページが持つ値を設定
# @param [String] key キー値
# @param [Object] value 設定値(ハッシュ配列または値)
# @param [Boolean] isCache このページでのみ保持させるか
setPageValue = (key, value, isCache = false) ->
  f = @
  # ハッシュを要素の文字列に変換
  makeElementStr = (ky, val) ->
    if jQuery.type(val) != "object"
      # サニタイズする
      val = sanitaizeEncode(val)
      return "<input type='hidden' class=#{ky} value='#{val}' />"

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

# ページが持つ値を削除
# @param [String] key キー値
removePageValue = (key) ->
  getPageValue(key, true)

# サニタイズ エンコード
# @property [String] str 対象文字列
sanitaizeEncode =  (str) ->
  if str? && typeof str == "string"
    return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#39;');
  else
    return str


# サニタイズ デコード
# @property [String] str 対象文字列
sanitaizeDecode = (str) ->
  if str? && typeof str == "string"
    return str.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '"').replace(/&#39;/g, '\'').replace(/&amp;/g, '&');
  else
    return str


# 画面共通の初期化処理 ajaxでサーバから読み込む等
do ->
  window.loadedItemTypeList = []
  window.loadedClassList = []

$ ->
  window.drawingCanvas = document.getElementById('canvas_container')
  window.drawingContext = drawingCanvas.getContext('2d')