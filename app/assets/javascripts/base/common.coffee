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

  # 変数の型チェック
  # @return [string] 型
  @typeOfValue = do ->
    classToType = {}
    for name in "Boolean Number String Function Array Date RegExp Undefined Null".split(" ")
      classToType["[object " + name + "]"] = name.toLowerCase()
    (obj) ->
      strType = Object::toString.call(obj)
      classToType[strType] or "object"

  # イベントのIDを作成
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

  # Mainコンテナを作成
  # @param [Integer] pageNum ページ番号
  # @param [Boolean] collapsed 初期表示でページを閉じた状態にするか
  @createdMainContainerIfNeeded: (pageNum, collapsed = false) ->
    root = $("##{Constant.Paging.ROOT_ID}")
    sectionClass = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', pageNum)
    pageSection = $(".#{sectionClass}", root)
    if !pageSection? || pageSection.length == 0
      # Tempからコピー
      temp = $("##{Constant.ElementAttribute.MAIN_TEMP_ID}").children(':first').clone(true)
      style = ''
      style += "z-index:#{Common.plusPagingZindex(0, pageNum)};"
      # TODO: pageflipを変更したら修正すること
      width = if collapsed then 'width: 0px;' else ''
      style += width
      temp = $(temp).wrap("<div class='#{sectionClass} section' style='#{style}'></div>").parent()
      root.append(temp)

  # Mainコンテナを削除
  # @param [Integer] pageNum ページ番号
  @removeMainContainer: (pageNum) ->
    root = $("##{Constant.Paging.ROOT_ID}")
    sectionClass = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', pageNum)
    $(".#{sectionClass}", root).remove()

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

  # クラスハッシュ配列からクラスを取り出し
  # @param [Boolean] isCommon 共通イベントか
  # @param [Integer] id EventIdまたはItemId
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
  # @param [Boolean] isCommon 共通イベントか
  # @param [Integer] id EventIdまたはItemId
  # @param [Class] value クラス
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

  # インスタンス作成
  # @param [Boolean] isCommonEvent 共通イベントか
  # @param [Integer] classMapId EventIdまたはItemId
  # @return [Object] インスタンス
  @newInstance = (isCommonEvent, classMapId) ->
    if typeof isCommonEvent == "boolean"
      if isCommonEvent
        isCommonEvent = "1"
      else
        isCommonEvent = "0"

    if typeof id != "string"
      id = String(id)

    if !window.instanceMap?
      window.instanceMap = {}
    # インスタンスを保存する
    instance = new (Common.getClassFromMap(isCommonEvent, classMapId))()
    window.instanceMap[instance.id] = instance
    return instance

  # インスタンス取得
  # @param [Boolean] isCommonEvent 共通イベントか
  # @param [Integer] id イベントID
  # @param [Integer] classMapId EventIdまたはItemId
  # @return [Object] インスタンス
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
  # @param [Boolean] isCommonEvent 共通イベントか
  # @param [Integer] id イベントID
  # @param [Integer] classMapId EventIdまたはItemId
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
    if tes.length <= 0
      if callback?
        callback()
        return

    for idx in [tes.length - 1 .. 0] by -1
      te = tes[idx]
      item = window.instanceMap[te.id]
      if item?
        item.initWithEvent(te)
        item.stopPreview( ->
          item.updateEventBefore()
          previewinitCount += 1
          if previewinitCount >= tes.length && callback?
            callback()
        )
      else
        previewinitCount += 1
        if previewinitCount >= tes.length && callback?
          callback()

  # アクションタイプからアクションタイプクラス名を取得
  @getActionTypeClassNameByActionType = (actionType) ->
    if parseInt(actionType) == Constant.ActionEventHandleType.CLICK
      return Constant.ActionEventTypeClassName.CLICK
    else if parseInt(actionType) == Constant.ActionEventHandleType.SCROLL
      return Constant.ActionEventTypeClassName.SCROLL
    return null

  # 日付フォーマット
  @formatDate = (date, format = 'YYYY-MM-DD hh:mm:ss') ->
    format = format.replace(/YYYY/g, date.getFullYear())
    format = format.replace(/MM/g, ('0' + (date.getMonth() + 1)).slice(-2))
    format = format.replace(/DD/g, ('0' + date.getDate()).slice(-2))
    format = format.replace(/hh/g, ('0' + date.getHours()).slice(-2))
    format = format.replace(/mm/g, ('0' + date.getMinutes()).slice(-2))
    format = format.replace(/ss/g, ('0' + date.getSeconds()).slice(-2))
    if format.match(/S/g)
      milliSeconds = ('00' + date.getMilliseconds()).slice(-3)
      length = format.match(/S/g).length
      for i in [0..length]
        format = format.replace(/S/, milliSeconds.substring(i, i + 1))
    return format

  # 時間差を計算
  @diffTime = (future, past) ->
    diff = future - past
    ret = {}
    ret.seconds = parseInt(diff / 1000)
    ret.minutes = parseInt(ret.seconds / 60)
    ret.hours = parseInt(ret.minutes / 60)
    ret.day = parseInt(ret.hours / 24)
    ret.week = parseInt(ret.day / 7)
    ret.month = parseInt(ret.day / 30)
    ret.year = parseInt(ret.day / 365)
    return ret

  # 時間差を表示
  @diffAlmostTime = (future, past) ->
    diffTime = @diffTime(future, past)
    span = null
    ret = null
    seconds = diffTime.seconds
    if seconds > 0
      span = if seconds == 1 then 'second' else 'seconds'
      ret = "#{seconds} #{span} ago"
    minutes = diffTime.minutes
    if minutes > 0
      span = if minutes == 1 then 'minute' else 'minutes'
      ret = "#{minutes} #{span} ago"
    hours = diffTime.hours
    if hours > 0
      span = if hours == 1 then 'hour' else 'hours'
      ret = "#{hours} #{span} ago"
    day = diffTime.day
    if day > 0
      span = if day == 1 then 'day' else 'days'
      ret = "#{day} #{span} ago"
    week = diffTime.week
    if week > 0
      span = if week == 1 then 'week' else 'weeks'
      ret = "#{week} #{span} ago"
    month = diffTime.month
    if month > 0
      span = if month == 1 then 'month' else 'months'
      ret = "#{month} #{span} ago"
    year = diffTime.year
    if year > 0
      span = if year == 1 then 'year' else 'years'
      ret = "#{year} #{span} ago"
    return ret

  @showModalView = (type) ->
    self = @
    emt = $('body').children(".modal-content.#{type}")

    $(@).blur()
    if $("#modal-overlay")[0]?
      return false

    _centering = ->
      w = $(window).width()
      h = $(window).height()
      cw = emt.outerWidth()
      ch = emt.outerHeight()
      emt.css({"left": ((w - cw)/2) + "px","top": ((h - ch)/2) + "px"})

    _show = ->
      $("body").append( '<div id="modal-overlay"></div>' )
      $("#modal-overlay").css('display', 'block')
      _centering.call(@)
      emt.css('display', 'block')
      $("#modal-overlay,#modal-close").unbind().click( ->
        $(".modal-content,#modal-overlay").css('display', 'none')
        $('#modal-overlay').remove() ;
      )

    if !emt? || emt.length == 0
      $.ajax(
        {
          url: "/modal_view/show"
          type: "GET"
          data: {
            type: type
          }
          dataType: "json"
          success: (data)->
            $('body').append(data.modalHtml)
            emt = $('body').children(".modal-content.#{type}")
            _show.call(self)
          error: (data) ->
        }
      )
    else
      _show.call(self)

  @plusPagingZindex: (zindex, pn = PageValue.getPageNum()) ->
    return (window.pageNumMax - pn) * (Constant.Zindex.EVENTFLOAT + 1) + zindex

  @minusPagingZindex: (zindex, pn = PageValue.getPageNum()) ->
    return zindex - (window.pageNumMax - pn) * (Constant.Zindex.EVENTFLOAT + 1)

  # アイテムを削除
  @removeAllItem = (pageNum = null) ->
    if pageNum?
      pageValues = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix(pageNum))
      for k, obj of pageValues
        objId = obj.value.id
        itemId = obj.value.itemId
        if objId?
          $("##{objId}").remove()
          delete window.instanceMap[objId]
    else
      for k, v of Common.getCreatedItemObject()
        if v.getJQueryElement?
          v.getJQueryElement().remove()
      window.instanceMap = {}

# 画面共通の初期化処理 ajaxでサーバから読み込む等
do ->
  window.loadedClassList = {}
  window.classMap = {}

