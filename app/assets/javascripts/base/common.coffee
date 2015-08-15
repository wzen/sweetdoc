class Common
  # ブラウザ対応のチェック
  # @return [Boolean] 処理結果
  @checkBlowserEnvironment = ->
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

  @typeOfValue = do ->
    classToType = {}
    for name in "Boolean Number String Function Array Date RegExp Undefined Null".split(" ")
      classToType["[object " + name + "]"] = name.toLowerCase()
    (obj) ->
      strType = Object::toString.call(obj)
      classToType[strType] or "object"

  # アイテムのIDを作成
  # @return [Int] 生成したID
  @generateId = ->
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
  @makeClone = (obj) ->
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
  @focusToTarget = (target) ->
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
# @param [Object] value 設定値(ハッシュ配列または値)
# @param [Boolean] isCache このページでのみ保持させるか
getPageValue = (key, withRemove = false) ->
  _getPageValue(key, withRemove, Constant.PageValueKey.PV_ROOT)

# タイムラインの値を取得
# @param [String] key キー値
getTimelinePageValue = (key) ->
  _getPageValue(key, false, Constant.PageValueKey.TE_ROOT)

# 共通設定値を取得
# @param [String] key キー値
getSettingPageValue = (key) ->
  _getPageValue(key, false, Setting.PageValueKey.ROOT)

# ページが持つ値を取得
# @param [String] key キー値
# @param [Boolean] withRemove 取得後に値を消去するか
# @param [String] rootId Root要素ID
# @return [Object] ハッシュ配列または値で返す
_getPageValue = (key, withRemove, rootId) ->
  f = @
  # div以下の値をハッシュとしてまとめる
  takeValue = (element) ->
    ret = null
    c = $(element).children()
    if c? && c.length > 0
      $(c).each((e) ->
        k = @.classList[0]
        if !ret?
          if jQuery.isNumeric(k)
            ret = []
          else
            ret = {}

        v = null
        if @.tagName == "INPUT"
          # サニタイズをデコード
          v = sanitaizeDecode($(@).val())
          if jQuery.isNumeric(v)
            v = Number(v)
          else if v == "true" || v == "false"
            v = if v == "true" then true else false
        else
          v = takeValue.call(f, @)

        if jQuery.type(ret) == "array" && jQuery.isNumeric(k)
          k = Number(k)
        ret[k] = v
        return true
      )
      return ret
    else
      return null

  value = null
  root = $("##{rootId}")
  keys = key.split(Constant.PageValueKey.PAGE_VALUES_SEPERATOR)
  keys.forEach((k, index) ->
    root = $(".#{k}", root)
    if !root? || root.length == 0
      value = null
      return
    if keys.length - 1 == index
      if root[0].tagName == "INPUT"
        value = sanitaizeDecode(root.val())
        if jQuery.isNumeric(value)
          value = Number(value)
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
  _setPageValue(key, value, isCache, Constant.PageValueKey.PV_ROOT, false)

# タイムラインの値を設定
# @param [String] key キー値
# @param [Object] value 設定値(ハッシュ配列または値)
setTimelinePageValue = (key, value) ->
  _setPageValue(key, value, false, Constant.PageValueKey.TE_ROOT, true)

# 共通設定値を設定
# @param [String] key キー値
# @param [Object] value 設定値(ハッシュ配列または値)
# @param [Boolean] giveName name属性を付与するか
setSettingPageValue = (key, value, giveName = false) ->
  _setPageValue(key, value, false, Setting.PageValueKey.ROOT, giveName)

# ページが持つ値を設定
# @param [String] key キー値
# @param [Object] value 設定値(ハッシュ配列または値)
# @param [Boolean] isCache このページでのみ保持させるか
# @param [String] rootId Root要素ID
# @param [Boolean] giveName name属性を付与するか
_setPageValue = (key, value, isCache, rootId, giveName) ->
  f = @
  # ハッシュを要素の文字列に変換
  makeElementStr = (ky, val, kyName) ->
    if val == null || val == "null"
      return ''

    kyName += "[#{ky}]"
    if jQuery.type(val) != "object" && jQuery.type(val) != "array"
      # サニタイズする
      val = sanitaizeEncode(val)
      name = ""
      if giveName
        name = "name = #{kyName}"

      if ky == 'w'
        console.log(val)

      return "<input type='hidden' class='#{ky}' value='#{val}' #{name} />"

    ret = ""
    for k, v of val
      ret += makeElementStr.call(f, k, v, kyName)

    return "<div class=#{ky}>#{ret}</div>"

  cacheClassName = 'cache'
  root = $("##{rootId}")
  parentClassName = null
  keys = key.split(Constant.PageValueKey.PAGE_VALUES_SEPERATOR)
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
      if parentClassName == null
        parentClassName = k
      else
        parentClassName += "[#{k}]"
    else
      if root? && root.length > 0
        # 要素が存在する場合は消去して上書き
        root.remove()
      # 要素作成
      root = jQuery(makeElementStr.call(f, k, value, parentClassName)).appendTo(parent)
      if isCache
        root.addClass(cacheClassName)
  )

# ソートしたタイムラインリストを取得
getTimelinePageValueSortedListByNum = ->
  timelinePageValues = getTimelinePageValue(Constant.PageValueKey.TE_PREFIX)
  if !timelinePageValues?
    return []

  count = getTimelinePageValue(Constant.PageValueKey.TE_COUNT)
  timelineList = new Array(count)

  # ソート
  for k, v of timelinePageValues
    if k.indexOf(Constant.PageValueKey.TE_NUM_PREFIX) == 0
      index = parseInt(k.substring(Constant.PageValueKey.TE_NUM_PREFIX.length)) - 1
      timelineList[index] = v

  return timelineList

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

# ハッシュ配列からクラスを取り出し
getClassFromMap = (isCommon, id) ->
  if !window.classMap?
    window.classMap = {}

  c = isCommon
  i = id
  if typeof c == "boolean"
    if c
      c = "1"
    else
      c = "0"

  if typeof i != "string"
    i = String(id)

  if !window.classMap[c]? || !window.classMap[c][i]?
    return null

  return window.classMap[c][i]

# クラスをハッシュ配列に保存
setClassToMap = (isCommon, id, value) ->
  c = isCommon
  i = id
  if typeof c == "boolean"
    if c
      c = "1"
    else
      c = "0"

  if typeof i != "string"
    i = String(id)

  if !window.classMap?
    window.classMap = {}
  if !window.classMap[c]?
    window.classMap[c] = {}

  window.classMap[c][i] = value

# インスタンス取得
getInstanceFromMap = (timelineEvent) ->
  isCommonEvent = timelineEvent[TimelineEvent.PageValueKey.IS_COMMON_EVENT]
  id = if isCommonEvent then timelineEvent[TimelineEvent.PageValueKey.COMMON_EVENT_ID] else timelineEvent[TimelineEvent.PageValueKey.ID]
  classMapId = if isCommonEvent then timelineEvent[TimelineEvent.PageValueKey.COMMON_EVENT_ID] else timelineEvent[TimelineEvent.PageValueKey.ITEM_ID]

  if typeof isCommonEvent == "boolean"
    if isCommonEvent
      isCommonEvent = "1"
    else
      isCommonEvent = "0"

  if typeof id != "string"
    id = String(id)

  setInstanceFromMap(isCommonEvent, id, classMapId)
  return window.instanceMap[isCommonEvent][id]

# インスタンス設定(上書きはしない)
setInstanceFromMap = (isCommonEvent, id, itemId = id) ->
  if !window.instanceMap?
    window.instanceMap = {}

  if typeof isCommonEvent == "boolean"
    if isCommonEvent
      isCommonEvent = "1"
    else
      isCommonEvent = "0"

  if typeof id != "string"
    id = String(id)

  if !window.instanceMap[isCommonEvent]?
    !window.instanceMap[isCommonEvent] = {}
  if !window.instanceMap[isCommonEvent][id]?
    # インスタンスを保存する
    window.instanceMap[isCommonEvent][id] = new (getClassFromMap(isCommonEvent, itemId))()

getCreatedItemObject = ->
  ret = {}
  for k, v of createdObject
    if v instanceof CommonEventBase == false
      ret[k] = v
  return ret


clearItemAndEvent = ->



# 画面共通の初期化処理 ajaxでサーバから読み込む等
do ->
  window.loadedItemTypeList = []
  window.loadedClassList = {}
  window.classMap = {}

$ ->
  window.drawingCanvas = document.getElementById('canvas_container')
  window.drawingContext = drawingCanvas.getContext('2d')