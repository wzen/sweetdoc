# イベントリスナー Extend
class EventBase extends Extend
  # 初期化
  initWithEvent: (event) ->
    @setEvent(event)

  # アクションの初期化(閲覧モードのみ使用される)
  setEvent: (event) ->
    @event = event
    @isFinishedEvent = false
    @doPreviewLoop = false
    # アクションメソッドの設定
    @setMethod()

  # アクションメソッドの設定
  setMethod: ->
    actionType = @event[EventPageValueBase.PageValueKey.ACTIONTYPE]
    methodName = @event[EventPageValueBase.PageValueKey.METHODNAME]
    if !@constructor.prototype[methodName]?
      # メソッドが見つからない場合
      return

    # スクロールイベント
    if actionType == Constant.ActionEventHandleType.SCROLL
      @scrollEvent = @scrollRootFunc

    # クリックイベント
    else if actionType == Constant.ActionEventHandleType.CLICK
      @clickEvent = @clickRootFunc

  # リセット(アクション前に戻す)
  # @abstract
  reset: ->
    @updateEventBefore()
    @isFinishedEvent = false
    return

  # プレビュー開始
  preview: (event) ->
    @stopPreview( =>
      _preview.call(@, event)
    )

  _preview = (event) ->
    drawDelay = 30 # 0.03秒毎スクロール描画
    loopDelay = 1000 # 1秒毎イベント実行
    loopMaxCount = 5 # ループ5回
    @initWithEvent(event)
    methodName = @event[EventPageValueBase.PageValueKey.METHODNAME]
    @willChapter(methodName)
    @appendCssIfNeeded(methodName)

    method = @constructor.prototype[methodName]
    actionType = @event[EventPageValueBase.PageValueKey.ACTIONTYPE]
    # イベントループ
    @doPreviewLoop = true
    loopCount = 0
    @previewTimer = null
    if actionType == Constant.ActionEventHandleType.SCROLL

      p = 0
      _draw = =>
        if @doPreviewLoop
          if @previewTimer?
            clearTimeout(@previewTimer)
            @previewTimer = null
          @previewTimer = setTimeout( =>
            method.call(@, p)
            p += 1
            if p >= @scrollLength()
              p = 0
              _loop.call(@)
            else
              _draw.call(@)
          , drawDelay)
        else
          if @previewFinished?
            @previewFinished()
            @previewFinished = null

      _loop = =>
        if @doPreviewLoop
          loopCount += 1
          if loopCount >= loopMaxCount
            @stopPreview()

          if @previewTimer?
            clearTimeout(@previewTimer)
            @previewTimer = null
          @previewTimer = setTimeout( =>
            _draw.call(@)
          , loopDelay)
          if !@doPreviewLoop
            @stopPreview()
        else
          if @previewFinished?
            @previewFinished()
            @previewFinished = null

      _draw.call(@)

    else if actionType == Constant.ActionEventHandleType.CLICK
      _loop = =>
        if @doPreviewLoop
          loopCount += 1
          if loopCount >= loopMaxCount
            @stopPreview()

          if @previewTimer?
            clearTimeout(@previewTimer)
            @previewTimer = null
          @previewTimer = setTimeout( =>
            method.call(@, null, _loop)
          , loopDelay)
        else
          if @previewFinished?
            @previewFinished()
            @previewFinished = null

      method.call(@, null, _loop)

  # プレビューを停止
  stopPreview: (callback = null) ->
    _stop = ->
      if @previewTimer?
        clearTimeout(@previewTimer)
        @previewTimer = null
      if callback?
        callback()

    if @doPreviewLoop
      @doPreviewLoop = false
      @previewFinished = =>
        _stop.call(@)

    else
      _stop.call(@)

  # JQueryエレメントを取得
  # @abstract
  getJQueryElement: ->
    return null

  # チャプターを進める
  nextChapter: ->
    if window.eventAction?
      window.eventAction.thisPage().nextChapter()

  # チャプター開始前イベント
  willChapter: (methodName) ->
    actionType = @event[EventPageValueBase.PageValueKey.ACTIONTYPE]
    if actionType == Constant.ActionEventHandleType.SCROLL
      @scrollValue = 0

    # 状態をイベント前に戻す
    @updateEventBefore()
    return

  # チャプター終了時イベント
  # @abstract
  didChapter: (methodName) ->
    return

  # スクロール基底メソッド
  scrollRootFunc: (x, y, complete = null) ->
    if !@event[EventPageValueBase.PageValueKey.METHODNAME]?
      # メソッドが無い場合
      return

    methodName = @event[EventPageValueBase.PageValueKey.METHODNAME]
    if @isFinishedEvent
      # 終了済みの場合
      return

    # 動作済みフラグON
    if window.eventAction?
      window.eventAction.thisPage().thisChapter().doMoveChapter = true

    console.log("y:#{y}")
    if y >= 0
      @scrollValue += parseInt((y + 9) / 10)
    else
      @scrollValue += parseInt((y - 9) / 10)

    sPoint = parseInt(@event[EventPageValueBase.PageValueKey.SCROLL_POINT_START])
    ePoint = parseInt(@event[EventPageValueBase.PageValueKey.SCROLL_POINT_END])
    # スクロール指定範囲外なら反応させない
    if @scrollValue < sPoint || @scrollValue > ePoint
      return
    @scrollValue = if @scrollValue < sPoint then sPoint else @scrollValue
    @scrollValue = if @scrollValue > ePoint then ePoint else @scrollValue

    (@constructor.prototype[methodName]).call(@, @scrollValue - sPoint)

    if @scrollValue == ePoint
      @isFinishedEvent = true
      if complete?
        complete()

  # スクロールの長さを取得
  scrollLength: ->
    return parseInt(@event[EventPageValueBase.PageValueKey.SCROLL_POINT_END]) - parseInt(@event[EventPageValueBase.PageValueKey.SCROLL_POINT_START])

  # スクロール基底メソッド
  clickRootFunc: (e, complete = null) ->
    # 動作済みフラグON
    if window.eventAction?
      window.eventAction.thisPage().thisChapter().doMoveChapter = true
    methodName = @event[EventPageValueBase.PageValueKey.METHODNAME]
    (@constructor.prototype[methodName]).call(@, e, complete)

  # CSS
  # @abstract
  cssElement: (methodName) ->
    return null

  # CSS追加処理
  appendCssIfNeeded : (methodName) ->
    ce = @cssElement(methodName)
    if ce?
      # CSSが存在する場合は削除して入れ替え
      @removeCss(methodName)
      funcName = "#{methodName}_#{@id}"
      window.cssCode.append("<div class='#{funcName}'><style type='text/css'> #{ce} </style></div>")

  # CSS削除処理
  removeCss: (methodName) ->
    funcName = "#{methodName}_#{@id}"
    window.cssCode.find(".#{funcName}").remove()

  # イベント後の表示状態にする
  # @abstract
  updateEventAfter: ->

  # イベント前の表示状態にする
  # @abstract
  updateEventBefore: ->

  # ページング時
  clearPaging: (methodName) ->
    @removeCss(methodName)

  # アイテムの情報をページ値に保存
  # @property [Boolean] isCache キャッシュとして保存するか
  setItemAllPropToPageValue: (isCache = false)->
    prefix_key = if isCache then PageValue.Key.instanceValueCache() else PageValue.Key.instanceValue()
    prefix_key = prefix_key.replace('@id', @id)
    obj = @getMinimumObject()
    PageValue.setInstancePageValue(prefix_key, obj)

class CommonEventBase extends EventBase
  # 初期化
  initWithEvent: (event) ->
    super(event)

class ItemEventBase extends EventBase
  # 初期化
  initWithEvent: (event) ->
    super(event)
    # インスタンス値設定
    objId = event[EventPageValueBase.PageValueKey.ID]
    instance = PageValue.getInstancePageValue(PageValue.Key.instanceValue().replace('@id', objId))
    @setMiniumObject(instance)
    # 描画してアイテムを作成
    # 表示非表示はwillChapterで切り替え
    @reDraw(false)

  # 最小限のデータを設定
  # @abstract
  setMiniumObject: (obj) ->
