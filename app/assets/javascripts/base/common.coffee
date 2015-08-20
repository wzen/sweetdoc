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

  # サニタイズ エンコード
  # @property [String] str 対象文字列
  @sanitaizeEncode =  (str) ->
    if str? && typeof str == "string"
      return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#39;');
    else
      return str

  # サニタイズ デコード
  # @property [String] str 対象文字列
  @sanitaizeDecode = (str) ->
    if str? && typeof str == "string"
      return str.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '"').replace(/&#39;/g, '\'').replace(/&amp;/g, '&');
    else
      return str

  # ハッシュ配列からクラスを取り出し
  @getClassFromMap = (isCommon, id) ->
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
  @setClassToMap = (isCommon, id, value) ->
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
  @getInstanceFromMap = (isCommonEvent, id, classMapId) ->
    if typeof isCommonEvent == "boolean"
      if isCommonEvent
        isCommonEvent = "1"
      else
        isCommonEvent = "0"

    if typeof id != "string"
      id = String(id)

    Common.setInstanceFromMap(isCommonEvent, id, classMapId)
    return window.instanceMap[id]

  # インスタンス設定(上書きはしない)
  @setInstanceFromMap = (isCommonEvent, id, classMapId) ->
    if typeof isCommonEvent == "boolean"
      if isCommonEvent
        isCommonEvent = "1"
      else
        isCommonEvent = "0"

    if typeof id != "string"
      id = String(id)

    if !window.instanceMap?
      window.instanceMap = {}
    if !window.instanceMap[id]?
      # インスタンスを保存する
      instance = new (Common.getClassFromMap(isCommonEvent, classMapId))()
      instance.id = id
      window.instanceMap[id] = instance

  # 生成したインスタンスの中からアイテムのみ取得
  @getCreatedItemObject = ->
    ret = {}
    for k, v of instanceMap
      if v instanceof CommonEventBase == false
        ret[k] = v
    return ret

  # 全てのアクションを元に戻す
  @clearAllEventChange: (callback = null) ->
    previewinitCount = 0
    tes = PageValue.getEventPageValueSortedListByNum()
    for idx in [tes.length - 1 .. 0] by -1
      te = tes[idx]
      item = window.instanceMap[te.id]
      item.setEvent(te)
      item.stopPreview( ->
        item.updateEventBefore()
        previewinitCount += 1
        if previewinitCount >= tes.length && callback?
          callback()
      )

  # アクションタイプからアクションタイプクラス名を取得
  @getActionTypeClassNameByActionType = (actionType) ->
    if parseInt(actionType) == Constant.ActionEventHandleType.CLICK
      return Constant.ActionEventTypeClassName.CLICK
    else if parseInt(actionType) == Constant.ActionEventHandleType.SCROLL
      return Constant.ActionEventTypeClassName.SCROLL
    return null

# 画面共通の初期化処理 ajaxでサーバから読み込む等
do ->
  window.loadedItemTypeList = []
  window.loadedClassList = {}
  window.classMap = {}

$ ->
  window.drawingCanvas = document.getElementById('canvas_container')
  window.drawingContext = drawingCanvas.getContext('2d')