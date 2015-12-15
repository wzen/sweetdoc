# アプリ内の共通メソッドクラス
class Common
  if gon?
    constant = gon.const
    # @property [String] MAIN_TEMP_ID mainコンテンツテンプレート
    @MAIN_TEMP_ID = constant.ElementAttribute.MAIN_TEMP_ID

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
    if !window.URL
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

  # オブジェクトの比較
  @isEqualObject: (obj1, obj2) ->
    _func = (o1, o2) ->
      if typeof o1 != typeof o2
        return false
      else if typeof o1 != 'object'
        return o1 == o2
      else
        if Object.keys(o1).length != Object.keys(o2).length
          return false
        ret = true
        for k, v of o1
          if _func(v, o2[k]) == false
            ret = false
            break
        return ret
    return _func(obj1, obj2)

  @diffEventObject: (obj1, obj2) ->
    _func = (o1, o2) ->
      if typeof o1 != typeof o2
        return o2
      else if typeof o1 != 'object'
        if o1 != o2
          return o2
        else
          # 一致
          return null
      else
        ret = {}
        for k, v of o1
          f = _func(v, o2[k])
          if f?
            ret[k] = f
        return if Object.keys(ret).length > 0 then ret else null
    obj = _func(obj1, obj2)
    console.log('diffEventObject')
    console.log(obj)
    return obj

  # オブジェクトがHTML要素か判定
  @isElement: (obj) ->
    return (typeof obj == "object") && (obj.length == 1) && (obj.get(0).nodeType ==1) && (typeof obj.get(0).style == "object") && (typeof obj.get(0).ownerDocument == "object")

  # Pagevalueから環境を反映
  @applyEnvironmentFromPagevalue = ->
    # タイトル名設定
    Common.setTitle(PageValue.getGeneralPageValue(PageValue.Key.PROJECT_NAME))
    # 画面サイズ設定
    @initScreenSize()
    # スクロール位置設定
    @initScrollContentsPosition()
    # Zoom
    @initZoom()

  # 環境の反映をリセット
  @resetEnvironment = ->
    Common.setTitle('')
    @initScreenSize(true)

  # タイトルを設定
  @setTitle = (title_name) ->
    if title_name?
      Navbar.setTitle(title_name)
      if !window.isWorkTable
        RunCommon.setTitle(title_name)

  # プロジェクト表示サイズ設定
  @initScreenSize = (reset = false) ->
    size = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE)
    if !reset && size? && size.width? && size.height?
      css = {
        width: size.width
        height: size.height
      }
      $('#project_wrapper').css(css)
    else
      # width,height -> 100%
      $('#project_wrapper').removeAttr('style')
      PageValue.setGeneralPageValue(PageValue.Key.SCREEN_SIZE, {})

    # Canvasサイズ更新
    @updateCanvasSize()

  @initScrollContentsPosition = ->
    position = PageValue.getScrollContentsPosition()
    if position?
      @updateScrollContentsPosition(position.top, position.left)
    else
      PageValue.setGeneralPageValue(PageValue.Key.displayPosition(), {top: 0, left: 0})

  @initZoom = ->
    zoom = PageValue.getGeneralPageValue(PageValue.Key.zoom())
    if zoom?
      window.mainWrapper.css('transform', "scale(#{zoom}, #{zoom})")
    else
      PageValue.setGeneralPageValue(PageValue.Key.zoom(), 1)

  # Canvasサイズ更新
  @updateCanvasSize = ->
    if window.drawingCanvas?
      $(window.drawingCanvas).attr('width', $('#pages').width())
      $(window.drawingCanvas).attr('height', $('#pages').height())

  # リサイズイベント設定
  @initResize = (resizeEvent = null) ->
    $(window).resize( ->
      # モーダル中央寄せ
      Common.modalCentering()

      if resizeEvent?
        resizeEvent()
    )

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
  # @return [Boolean] ページを作成したか
  @createdMainContainerIfNeeded: (pageNum, collapsed = false) ->
    root = $("##{Constant.Paging.ROOT_ID}")
    sectionClass = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', pageNum)
    pageSection = $(".#{sectionClass}", root)
    if !pageSection? || pageSection.length == 0
      # Tempからコピー
      temp = $("##{Common.MAIN_TEMP_ID}").children(':first').clone(true)
      style = ''
      style += "z-index:#{Common.plusPagingZindex(0, pageNum)};"
      # TODO: pageflipを変更したら修正すること
      width = if collapsed then 'width: 0px;' else ''
      style += width
      temp = $(temp).wrap("<div class='#{sectionClass} section' style='#{style}'></div>").parent()
      root.append(temp)
      return true
    else
      return false

  # Mainコンテナを削除
  # @param [Integer] pageNum ページ番号
  @removeMainContainer: (pageNum) ->
    root = $("##{Constant.Paging.ROOT_ID}")
    sectionClass = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', pageNum)
    $(".#{sectionClass}", root).remove()

  # ページ内のインスタンスを取得
  @instancesInPage = (pn = PageValue.getPageNum(), withCreateInstance = false, withInitFromPageValue = false) ->
    ret = []
    instances = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix(pn))
    for key, instance of instances
      value = instance.value
      if withCreateInstance
        classMapId = value.itemToken
        if !classMapId?
          classMapId = value.eventId
        obj = Common.getInstanceFromMap(value.eventId?, value.id, classMapId)
        if withInitFromPageValue
          obj.setMiniumObject(value)
      else
        obj = window.instanceMap[value.id]
      ret.push(obj)
    return ret

  # ページ内のアイテムインスタンスを取得
  @itemInstancesInPage = (pn = PageValue.getPageNum(), withCreateInstance = false, withInitFromPageValue = false) ->
    return $.grep(@instancesInPage(pn, withCreateInstance, withInitFromPageValue), (n) ->
      n instanceof ItemBase
    )

  # 最初にフォーカスするアイテムオブジェクトを取得
  @firstFocusItemObj = (pn = PageValue.getPageNum()) ->
    objs = @itemInstancesInPage(pn)
    obj = null
    for o in objs
      if o.visible && o.firstFocus
        obj = o
        return obj
    return obj

  # アイテム用のテンプレートHTMLをwrap
  @wrapCreateItemElement = (item, contents) ->
    w = """
      <div id="#{item.id}" class="item draggable resizable" style="position: absolute;top:#{item.itemSize.y}px;left:#{item.itemSize.x}px;width:#{item.itemSize.w }px;height:#{item.itemSize.h}px;z-index:#{Common.plusPagingZindex(item.zindex)}"><div class="item_wrapper"><div class='item_contents'></div></div></div>
    """
    return $(contents).wrap(w).closest('.item')

  # アイテムに対してフォーカスする
  # @param [Object] target 対象アイテム
  # @param [Fucntion] callback コールバック
  @focusToTarget = (target, callback = null, immediate = false) ->
    # col-xs-9 → 75% padding → 15px

    diff =
      top: (scrollContents.scrollTop() + (scrollContents.height() - $(target).height()) * 0.5) - $(target).get(0).offsetTop
      left: (scrollContents.scrollLeft() + (scrollContents.width() - $(target).width()) * 0.5) - $(target).get(0).offsetLeft

    @updateScrollContentsPosition(scrollContents.scrollTop() - diff.top, scrollContents.scrollLeft() - diff.left, immediate, callback)

  # スクロール位置の更新
  @updateScrollContentsPosition: (top, left, immediate = true, callback = null) ->
    PageValue.setDisplayPosition(top, left)
    if immediate
      window.scrollContents.scrollTop(top)
      window.scrollContents.scrollLeft(left)
      if callback?
        callback()
    else
      window.scrollContents.animate(
        {
          scrollTop: top
          scrollLeft: left
        }
      , 500, ->
        if callback?
          callback()
      )

  @updateScrollContentsFromPagevalue: ->
    position = PageValue.getScrollContentsPosition()
    if !position?
      position = {top: window.scrollInsideWrapper.height() * 0.5, left: window.scrollInsideWrapper.width() * 0.5}
      PageValue.setDisplayPosition(position.top, position.left)
    @updateScrollContentsPosition(position.top, position.left)

  # サニタイズ エンコード
  # @property [String] str 対象文字列
  # @return [String] 変換後文字列
  @sanitaizeEncode =  (str) ->
    if str? && typeof str == "string"
      return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#39;');
    else
      return str

  # サニタイズ デコード
  # @property [String] str 対象文字列
  # @return [String] 変換後文字列
  @sanitaizeDecode = (str) ->
    if str? && typeof str == "string"
      return str.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '"').replace(/&#39;/g, '\'').replace(/&amp;/g, '&');
    else
      return str

  # クラスハッシュ配列からクラスを取り出し
  # @param [Boolean] isCommon 共通イベントか
  # @param [Integer] dist EventIdまたはItemToken
  # @return [Object] 対象クラス
  @getClassFromMap = (isCommon, dist) ->
    if !window.classMap?
      window.classMap = {}

    c = isCommon
    i = dist
    if typeof c == "boolean"
      if c
        c = "1"
      else
        c = "0"

    if typeof i != "string"
      i = String(dist)

    if !window.classMap[c]? || !window.classMap[c][i]?
      return null

    return window.classMap[c][i]

  # クラスをハッシュ配列に保存
  # @param [Boolean] isCommon 共通イベントか
  # @param [Integer] id EventIdまたはItemToken
  # @param [Class] value クラス
  @setClassToMap = (isCommon, dist, value) ->
    c = isCommon
    i = dist
    if typeof c == "boolean"
      if c
        c = "1"
      else
        c = "0"

    if typeof i != "string"
      i = String(dist)

    if !window.classMap?
      window.classMap = {}
    if !window.classMap[c]?
      window.classMap[c] = {}

    window.classMap[c][i] = value

  # インスタンス取得
  # @param [Boolean] isCommonEvent 共通イベントか
  # @param [Integer] id イベントID
  # @param [Integer] classMapId EventIdまたはItemToken
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
  # @param [Integer] classMapId EventIdまたはItemToken
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
      # インスタンス値が存在する場合、初期化
      obj = PageValue.getInstancePageValue(PageValue.Key.instanceValue(id))
      if obj
        instance.setMiniumObject(obj)
      window.instanceMap[id] = instance

  # 生成したインスタンスの中からアイテムのみ取得
  # @return [Array] アイテムインスタンス配列
  @allItemInstances = ->
    ret = {}
    for k, v of instanceMap
      if v instanceof CommonEventBase == false
        ret[k] = v
    return ret

  # 全てのアクションを元に戻す
  # @param [Function] callback コールバック
  @clearAllEventAction: (callback = null) ->
    # EventPageValueを読み込み、全てイベント実行前(updateEventBefore)にする

    self = @
    tesArray = []
    tesArray.push(PageValue.getEventPageValueSortedListByNum(PageValue.Key.EF_MASTER_FORKNUM))
    forkNum = PageValue.getForkNum()
    if forkNum > 0
      for i in [1..forkNum]
        # フォークデータを含める
        tesArray.push(PageValue.getEventPageValueSortedListByNum(i))

    callbackCount = 0

    _callback = ->
      callbackCount += 1
      if callbackCount >= tesArray.length
        if callback?
          callback()

    for tes in tesArray
      previewinitCount = 0
      if tes.length <= 0
        _callback.call(self)
        break

      for idx in [tes.length - 1 .. 0] by -1
        te = tes[idx]
        item = window.instanceMap[te.id]
        if item?
          item.initEvent(te)
          item.stopPreview( ->
            item.updateEventBefore()
            previewinitCount += 1
            if previewinitCount >= tes.length
              _callback.call(self)
          )
        else
          previewinitCount += 1
          if previewinitCount >= tes.length
            _callback.call(self)

  # アクションタイプからアクションタイプクラス名を取得
  # @param [Integer] actionType アクションタイプID
  # @return [String] アクションタイプクラス名
  @getActionTypeClassNameByActionType = (actionType) ->
    if parseInt(actionType) == Constant.ActionType.CLICK
      return Constant.TimelineActionTypeClassName.CLICK
    else if parseInt(actionType) == Constant.ActionType.SCROLL
      return Constant.TimelineActionTypeClassName.SCROLL
    return null

  # コードのアクションタイプからアクションタイプを取得
  # @param [Integer] actionType アクションタイプID
  # @return [String] アクションタイプクラス名
  @getActionTypeByCodingActionType = (actionType) ->
    if actionType == 'click'
      return Constant.ActionType.CLICK
    else if actionType == 'scroll'
      return Constant.ActionType.SCROLL
    return null

  # 日付をフォーマットで変換
  # @param [Date] date 対象日付
  # @param [String] format 変換フォーマット
  # @return [String] フォーマット後日付
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
  # @param [Integer] future 未来日ミリ秒
  # @param [Integer] past 過去日ミリ秒
  # @return [Object] 差分オブジェクト
  @calculateDiffTime = (future, past) ->
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
  # @param [Integer] future 未来日ミリ秒
  # @param [Integer] past 過去日ミリ秒
  # @return [String] 表示
  @displayDiffAlmostTime = (future, past) ->
    diffTime = @calculateDiffTime(future, past)
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
    if !ret?
      ret = ''
    return ret

  # 最終更新日時の時間差を取得
  @displayLastUpdateDiffAlmostTime = (update_at = null) ->
    lastSaveTime = if update_at? then update_at else PageValue.getGeneralPageValue(PageValue.Key.LAST_SAVE_TIME)
    if lastSaveTime?
      n = $.now()
      d = new Date(lastSaveTime)
      return Common.displayDiffAlmostTime(n, d.getTime())
    else
      return null

  # 最新更新日時
  @displayLastUpdateTime = (update_at) ->
    date = new Date(update_at)
    diff = Common.calculateDiffTime($.now(), date)
    if diff.day > 0
      # 日で表示
      return @formatDate(date, 'YYYY/MM/DD')
    else
      # 時間で表示
      return @formatDate(date, 'hh:mm:ss')

  # モーダルビュー表示
  # @param [Integer] type モーダルビュータイプ
  # @param [Function] prepareShowFunc 表示前処理
  @showModalView = (type, enableOverlayClose = true, prepareShowFunc = null, prepareShowFuncParams = {}) ->
    self = @
    emt = $('body').children(".modal-content.#{type}")

    $(@).blur()
    if $("#modal-overlay")[0]?
      return false

    # 表示
    _show = ->
      $("body").append( '<div id="modal-overlay"></div>' )
      $("#modal-overlay").show()
      # センタリング
      Common.modalCentering.call(@)
      # ビューの高さ
      emt.css('max-height', $(window).height() * Constant.ModalView.HEIGHT_RATE)
      emt.show()
      $("#modal-overlay,#modal-close").unbind().click( ->
        if enableOverlayClose
          Common.hideModalView()
      )

    # 表示内容読み込み済みの場合はサーバアクセスなし
    if !emt? || emt.length == 0
      # サーバから表示内容読み込み
      $.ajax(
        {
          url: "/modal_view/show"
          type: "GET"
          data: {
            type: type
          }
          dataType: "json"
          success: (data)->
            if data.resultSuccess
              $('body').append(data.modalHtml)
              emt = $('body').children(".modal-content.#{type}")
              emt.hide()
              if prepareShowFunc?
                prepareShowFunc(emt, prepareShowFuncParams, ->
                  _show.call(self)
                )
              else
                _show.call(self)
                console.log('/modal_view/show server error')
          error: (data) ->
            console.log('/modal_view/show ajax error')
        }
      )
    else
      if prepareShowFunc?
        prepareShowFunc(emt, prepareShowFuncParams, ->
          _show.call(self)
        )
      else
        _show.call(self)

  # 中央センタリング
  @modalCentering = (animation = false, b = null, c = null) ->
    emt = $('body').children(".modal-content")
    if emt?
      w = $(window).width()
      h = $(window).height()

      callback = null
      width = emt.outerWidth()
      height = emt.outerHeight()
      if b?
        if $.type(b) == 'function'
          callback = b
        else if $.type(b) == 'object'
          width = b.width
          height = b.height
      if c?
        callback = c
      cw = width
      ch = height
      if ch > h * Constant.ModalView.HEIGHT_RATE
        ch = h * Constant.ModalView.HEIGHT_RATE

      if animation
        emt.animate({"left": ((w - cw)/2) + "px","top": ((h - ch)/2 - 80) + "px"}, 300, 'linear', callback)
      else
        emt.css({"left": ((w - cw)/2) + "px","top": ((h - ch)/2 - 80) + "px"})

  # モーダル非表示
  @hideModalView = ->
    $(".modal-content,#modal-overlay").hide()
    $('#modal-overlay').remove()

  # Zindexにページ分のZindexを加算
  # @param [Integer] zindex 対象zindex
  # @param [Integer] pn ページ番号
  # @return [Integer] 計算後zidnex
  @plusPagingZindex: (zindex, pn = PageValue.getPageNum()) ->
    return (window.pageNumMax - pn) * (Constant.Zindex.EVENTFLOAT + 1) + zindex

  # Zindexにページ分のZindexを減算
  # @param [Integer] zindex 対象zindex
  # @param [Integer] pn ページ番号
  # @return [Integer] 計算後zidnex
  @minusPagingZindex: (zindex, pn = PageValue.getPageNum()) ->
    return zindex - (window.pageNumMax - pn) * (Constant.Zindex.EVENTFLOAT + 1)

  # アイテムを削除
  # @param [Integer] pageNum ページ番号
  @removeAllItem = (pageNum = null) ->
    if pageNum?
      items = @instancesInPage(pageNum)
      for item in items
        if item instanceof CommonEvent
          # Singletonのキャッシュを削除
          CommonEvent.deleteInstance(item.id)
        else
          # アイテム削除
          item.removeItemElement()
        delete window.instanceMap[item.id]
    else
      for k, v of Common.allItemInstances()
        v.removeItemElement()
      window.instanceMap = {}
      # Singletonのキャッシュを削除
      CommonEvent.deleteAllInstance()

  # JSファイルをサーバから読み込む
  # @param [Int] itemToken アイテム種別
  # @param [Function] callback コールバック関数
  @loadItemJs = (itemTokens, callback = null) ->
    if jQuery.type(itemTokens) != "array"
      itemTokens = [itemTokens]

    itemTokens = $.grep(itemTokens, (n) ->
      # 読み込み済みのものは除外
      return !window.itemInitFuncList[n]?
    )
    # 読み込むIDがない場合はコールバック実行して終了
    if itemTokens.length == 0
      if callback?
        callback()
      return

    callbackCount = 0
    needReaditemTokens = []
    for itemToken in itemTokens
      if itemToken?
        if window.itemInitFuncList[itemToken]?
          # 読み込み済みなアイテムIDの場合
          window.itemInitFuncList[itemToken]()
          callbackCount += 1
          if callbackCount >= itemTokens.length
            if callback?
              # 既に全て読み込まれている場合はコールバック実行して終了
              callback()
            return
        else
          # Ajaxでjs読み込みが必要なアイテムID
          needReaditemTokens.push(itemToken)
      else
        callbackCount += 1

    # js読み込み
    data = {}
    data[Constant.ItemGallery.Key.ITEM_GALLERY_ACCESS_TOKEN] = needReaditemTokens
    $.ajax(
      {
        url: "/item_js/index"
        type: "POST"
        dataType: "json"
        data: data
        success: (data)->
          if data.resultSuccess
            callbackCount = 0
            dataIdx = 0
            _cb = (d) ->
              option = {}
              Common.availJs(d.item_access_token, d.js_src, option, =>
                PageValue.addItemInfo(d.item_access_token)
                if window.isWorkTable && EventConfig?
                  EventConfig.addEventConfigContents(d.item_access_token)
                dataIdx += 1
                if dataIdx >= data.indexes.length
                  if callback?
                    callback()
                else
                  _cb.call(@, data.indexes[dataIdx])
              )
            _cb.call(@, data.indexes[dataIdx])
          else
            console.log('/item_js/index server error')

        error: (data) ->
          console.log('/item_js/index ajax error')
      }
    )

  # イベントPageValueから全てのJSを取得
  @loadJsFromInstancePageValue: (callback = null, pageNum = PageValue.getPageNum()) ->
    pageValues = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix(pageNum))
    needitemTokens = []
    for k, obj of pageValues
      if obj.value.itemToken?
        if $.inArray(obj.value.itemToken, needitemTokens) < 0
          needitemTokens.push(obj.value.itemToken)

    @loadItemJs(needitemTokens, ->
      # コールバック
      if callback?
        callback()
    )

  # JSファイルを設定
  # @param [String] itemToken アイテムID
  # @param [String] jsSrc jsファイル名
  # @param [Function] callback 設定後のコールバック
  @availJs = (itemToken, jsSrc, option = {}, callback = null) ->
    window.loadedItemToken = itemToken
    s = document.createElement('script');
    s.type = 'text/javascript';
    # TODO: 認証コードの比較
    s.src = jsSrc;
    firstScript = document.getElementsByTagName('script')[0];
    firstScript.parentNode.insertBefore(s, firstScript);
    t = setInterval( ->
      if window.itemInitFuncList[itemToken]?
        clearInterval(t)
        window.itemInitFuncList[itemToken](option)
        window.loadedItemToken = null
        if callback?
          callback()
    , 500)

  # CanvasをBlobに変換
  @canvasToBlob = (canvas) ->
    type = 'image/jpeg'
    dataurl = canvas.toDataURL(type)
    bin = atob(dataurl.split(',')[1]);
    buffer = new Uint8Array(bin.length);
    for i in [0..(bin.length - 1)]
      buffer[i] = bin.charCodeAt(i)
    return new Blob([buffer.buffer], {type: type});

  # JSファイルを適用する
  @setupJsByList = (itemJsList, callback = null) ->

    _addItem = (item_access_token = null) ->
      if item_access_token?
        PageValue.addItemInfo(item_access_token)
        if EventConfig?
          EventConfig.addEventConfigContents(item_access_token)


    if itemJsList.length == 0
      if callback?
        callback()
      return

    loadedIndex = 0
    d = itemJsList[loadedIndex]
    _func = ->
      itemToken = d.item_access_token
      if window.itemInitFuncList[itemToken]?
          # 既に読み込まれている場合
        window.itemInitFuncList[itemToken]()
        #_addItem.call(@, itemToken)
        loadedIndex += 1
        if loadedIndex >= itemJsList.length
          # 全て読み込んだ後
          if callback?
            callback()
        else
          d = itemJsList[loadedIndex]
          _func.call()
        return

      option = {}
      Common.availJs(itemToken, d.js_src, option, ->
        _addItem.call(@, itemToken)
        loadedIndex += 1
        if loadedIndex >= itemJsList.length
          # 全て読み込んだ後
          if callback?
            callback()
        else
          d = itemJsList[loadedIndex]
          _func.call()
      )
    _func.call()

  # コンテキストメニュー初期化
  # @param [String] elementID HTML要素ID
  # @param [String] contextSelector
  # @param [Object] option オプション
  @setupContextMenu = (element, contextSelector, option) ->
    data = {
      preventContextMenuForPopup: true
      preventSelect: true
    }
    $.extend(data, option)
    element.contextmenu(data)

  # 色変更差分のキャッシュを取得
  @colorChangeCacheData = (beforeColor, afterColor, length, colorType = 'hex') ->
    ret = []

    cColors = new Array(3)
    if afterColor.indexOf('rgb') >= 0
      # 'rgb(r, g, b)'または'rgba(r, g, b, a)'のフォーマットを分解
      cColors = afterColor.replace('rgba', '').replace('rgb', '').replace('(', '').replace(')', '').split(',')
      for val, index in cColors
        cColors[index] = parseInt(val)
    if afterColor.length == 6 || (afterColor.length == 7 && afterColor.indexOf('#') == 0)
      # 'xxxxxxのフォーマットを分解'
      afterColor = afterColor.replace('#', '')
      cColors[0] = afterColor.substring(0, 2)
      cColors[1] = afterColor.substring(2, 4)
      cColors[2] = afterColor.substring(4, 6)
      for val, index in cColors
        cColors[index] = parseInt(val, 16)

    if beforeColor == 'transparent'
      # 透明から変更する場合は rgbaで出力
      for i in [0..length]
        ret[i] = "rgba(#{cColors[0]},#{cColors[1]},#{cColors[2]}, #{i / length})"
    else
      bColors = new Array(3)
      if beforeColor.indexOf('rgb') >= 0
        # 'rgb(r, g, b)'または'rgba(r, g, b, a)'のフォーマットを分解
        bColors = beforeColor.replace('rgba', '').replace('rgb', '').replace('(', '').replace(')', '').split(',')
        for val, index in bColors
          bColors[index] = parseInt(val)
      if beforeColor.length == 6 || (beforeColor.length == 7 && beforeColor.indexOf('#') == 0)
        # 'xxxxxxのフォーマットを分解'
        beforeColor = beforeColor.replace('#', '')
        bColors[0] = beforeColor.substring(0, 2)
        bColors[1] = beforeColor.substring(2, 4)
        bColors[2] = beforeColor.substring(4, 6)
        for val, index in bColors
          bColors[index] = parseInt(val, 16)

      rPer = (cColors[0] - bColors[0]) / length
      gPer = (cColors[1] - bColors[1]) / length
      bPer = (cColors[2] - bColors[2]) / length
      rp = rPer
      gp = gPer
      bp = bPer
      for i in [0..length]
        r = parseInt(bColors[0] + rp)
        g = parseInt(bColors[1] + gp)
        b = parseInt(bColors[2] + bp)
        if colorType == 'hex'
          o = "##{r.toString(16)}#{g.toString(16)}#{b.toString(16)}"
        else if colorType == 'rgb'
          o = "rgb(#{r},#{g},#{b})"
        ret[i] = o
        rp += rPer
        gp += gPer
        bp += bPer

    return ret

# 画面共通の初期化処理 ajaxでサーバから読み込む等
do ->
  window.classMap = {}
