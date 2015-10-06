# アプリ内の共通メソッドクラス
class Common
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

  # Pagevalueから環境を反映
  @applyEnvironmentFromPagevalue = ->
    # タイトル名設定
    Navbar.setTitle(PageValue.getGeneralPageValue(PageValue.Key.PROJECT_NAME))
    # 画面サイズ設定
    @initScreenSize()
    # スクロール位置設定
    @initScrollContentsPosition()
    # Zoom
    @initZoom()

  # 環境の反映をリセット
  @resetEnvironment = ->
    Navbar.setTitle('')
    @initScreenSize(true)

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
    if window.mainWrapper? && window.drawingCanvas?
      $(window.drawingCanvas).attr('width', window.mainWrapper.width())
      $(window.drawingCanvas).attr('height', window.mainWrapper.height())

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

  # アイテムに対してフォーカスする
  # @param [Object] target 対象アイテム
  # @param [Fucntion] callback コールバック
  @focusToTarget = (target, callback = null) ->
    # col-xs-9 → 75% padding → 15px
    targetMiddle =
      top: $(target).offset().top + $(target).height() * 0.5
      left: $(target).offset().left + $(target).width() * 0.5

    scrollTop = targetMiddle.top - scrollContents.height() * 0.5
    scrollLeft = targetMiddle.left - scrollContents.width() * 0.5
    # スライド
    #console.log("focusToTarget:: scrollTop:#{scrollTop} scrollLeft:#{scrollLeft}")
    zoom = PageValue.getGeneralPageValue(PageValue.Key.zoom())
    @updateScrollContentsPosition(scrollContents.scrollTop() + (scrollTop / zoom), scrollContents.scrollLeft() + (scrollLeft / zoom), false, callback)

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
      position = {top: window.scrollInside.height() * 0.5, left: window.scrollInside.width() * 0.5}
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
  # @param [Integer] id EventIdまたはItemId
  # @return [Object] 対象クラス
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
  # @return [Array] アイテムインスタンス配列
  @getCreatedItemInstances = ->
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
    return ret

  # モーダルビュー表示
  # @param [Integer] type モーダルビュータイプ
  # @param [Function] prepareShowFunc 表示前処理
  @showModalView = (type, prepareShowFunc = null, enableOverlayClose = true) ->
    self = @
    emt = $('body').children(".modal-content.#{type}")

    $(@).blur()
    if $("#modal-overlay")[0]?
      return false

    # 表示
    _show = ->
      if prepareShowFunc?
        prepareShowFunc(emt)
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
            $('body').append(data.modalHtml)
            emt = $('body').children(".modal-content.#{type}")
            _show.call(self)
          error: (data) ->
        }
      )
    else
      _show.call(self)

  # 中央センタリング
  @modalCentering = ->
    emt = $('body').children(".modal-content")
    if emt?
      w = $(window).width()
      h = $(window).height()
      cw = emt.outerWidth()
      ch = emt.outerHeight()
      if ch > h * Constant.ModalView.HEIGHT_RATE
        ch = h * Constant.ModalView.HEIGHT_RATE
      emt.css({"left": ((w - cw)/2) + "px","top": (((h - ch) - 80)/2) + "px"})

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
      pageValues = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix(pageNum))
      for k, obj of pageValues
        objId = obj.value.id
        itemId = obj.value.itemId
        if objId?
          $("##{objId}").remove()
          delete window.instanceMap[objId]
    else
      for k, v of Common.getCreatedItemInstances()
        if v.getJQueryElement?
          v.getJQueryElement().remove()
      window.instanceMap = {}

  # JSファイルをサーバから読み込む
  # @param [Int] itemId アイテム種別
  # @param [Function] callback コールバック関数
  @loadItemJs = (itemIds, callback = null) ->
    if jQuery.type(itemIds) != "array"
      itemIds = [itemIds]

    # 読み込むIDがない場合はコールバック実行して終了
    if itemIds.length == 0
      if callback?
        callback()
      return

    callbackCount = 0
    needReadItemIds = []
    for itemId in itemIds
      if itemId?
        if window.itemInitFuncList[itemId]?
          # 読み込み済みなアイテムIDの場合
          window.itemInitFuncList[itemId]()
          callbackCount += 1
          if callbackCount >= itemIds.length
            if callback?
              # 既に全て読み込まれている場合はコールバック実行して終了
              callback()
            return
        else
          # Ajaxでjs読み込みが必要なアイテムID
          needReadItemIds.push(itemId)
      else
        callbackCount += 1

    # js読み込み
    $.ajax(
      {
        url: "/item_js/index"
        type: "POST"
        dataType: "json"
        data: {
          itemIds: needReadItemIds
        }
        success: (data)->
          callbackCount = 0
          dataIdx = 0

          _cb = (d) ->
            if d.css_temp?
              option = {css_temp: d.css_temp}
            Common.availJs(d.item_id, d.js_src, option, =>
              PageValue.addItemInfo(d.item_id)
              if window.isWorkTable && EventConfig?
                EventConfig.addEventConfigContents(d.item_id)
              dataIdx += 1
              if dataIdx >= data.length
                if callback?
                  callback()
              else
                _cb.call(@, data[dataIdx])
            )
          _cb.call(@, data[dataIdx])

        error: (data) ->
      }
    )

  # イベントPageValueから全てのJSを取得
  @loadJsFromInstancePageValue: (callback = null, pageNum = PageValue.getPageNum()) ->
    pageValues = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix(pageNum))
    needItemIds = []
    for k, obj of pageValues
      if obj.value.itemId?
        if $.inArray(obj.value.itemId, needItemIds) < 0
          needItemIds.push(obj.value.itemId)

    @loadItemJs(needItemIds, ->
      # コールバック
      if callback?
        callback()
    )

  # JSファイルを設定
  # @param [String] itemId アイテムID
  # @param [String] jsSrc jsファイル名
  # @param [Function] callback 設定後のコールバック
  @availJs = (itemId, jsSrc, option = {}, callback = null) ->
    window.loadedItemId = itemId
    s = document.createElement('script');
    s.type = 'text/javascript';
    # TODO: 認証コードの比較
    s.src = jsSrc;
    firstScript = document.getElementsByTagName('script')[0];
    firstScript.parentNode.insertBefore(s, firstScript);
    t = setInterval( ->
      if window.itemInitFuncList[itemId]?
        clearInterval(t)
        window.itemInitFuncList[itemId](option)
        window.loadedItemId = null
        if callback?
          callback()
    , '500')

  # CanvasをBlobに変換
  @canvasToBlob = (canvas) ->
    type = 'image/jpeg'
    dataurl = canvas.toDataURL(type)
    bin = atob(dataurl.split(',')[1]);
    buffer = new Uint8Array(bin.length);
    for i in [0..(bin.length - 1)]
      buffer[i] = bin.charCodeAt(i)
    return new Blob([buffer.buffer], {type: type});


# 画面共通の初期化処理 ajaxでサーバから読み込む等
do ->
  window.classMap = {}

