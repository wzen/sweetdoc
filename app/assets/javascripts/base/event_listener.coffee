# イベントリスナー Extend
EventListener =
  # アクションの初期化(閲覧モードのみ使用される)
  setEvent: (timelineEvent) ->
    @timelineEvent = timelineEvent
    @isFinishedEvent = false
    if @previewTimer?
      clearInterval(@previewTimer)
    @previewTimer = null
    # アクションメソッドの設定
    @setMethod()

  # アクションメソッドの設定
  setMethod: ->
    actionType = @timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE]
    methodName = @timelineEvent[TimelineEvent.PageValueKey.METHODNAME]
    if !@constructor.prototype[methodName]?
      # メソッドが見つからない場合
      return

    # スクロールイベント
    if actionType == Constant.ActionEventHandleType.SCROLL
      @scrollEvent = @scrollRootFunc

    # クリックイベント
    else if actionType == Constant.ActionEventHandleType.CLICK
      @clickEvent = @constructor.prototype[methodName]

  # リセット(アクション前に戻す)
  # @abstract
  reset: ->
    @isFinishedEvent = false
    return

  # プレビュー
  preview: (timelineEvent) ->
    @setEvent(timelineEvent)

    actionType = timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE]
    # イベントループ
    if actionType == Constant.ActionEventHandleType.SCROLL
      p = 0
      @previewTimer = setInterval( =>
        (@constructor.prototype[methodName])(p)
        p += 1
        if p >= @scrollLength() - 1
          p = 0
      , 500)

    else if actionType == Constant.ActionEventHandleType.CLICK
      _loop = ->
        if @previewTimer?
          func(null, func)

      func = @constructor.prototype[methodName]
      @previewTimer = true # クリックの場合はタイマーに適当な値をセットしておく
      func(null, _loop.call(@))

  # JQueryエレメントを取得
  # @abstract
  getJQueryElement: ->
    return null

  # チャプターを進める
  nextChapter: ->
    if window.timeLine?
      window.timeLine.nextChapter()

  # チャプター開始前イベント
  willChapter: (methodName) ->
    actionType = @timelineEvent[TimelineEvent.PageValueKey.ACTIONTYPE]
    if actionType == Constant.ActionEventHandleType.SCROLL
      @scrollValue = 0

    return

  # チャプター終了時イベント
  # @abstract
  didChapter: (methodName) ->
    return

  # スクロール基底メソッド
  scrollRootFunc: (x, y, complete = null) ->
    if !@timelineEvent[TimelineEvent.PageValueKey.METHODNAME]?
      # メソッドが無い場合
      return

    methodName = @timelineEvent[TimelineEvent.PageValueKey.METHODNAME]
    if @isFinishedEvent
      # 終了済みの場合
      return

    console.log("y:#{y}")
    if y >= 0
      @scrollValue += parseInt((y + 9) / 10)
    else
      @scrollValue += parseInt((y - 9) / 10)

    sPoint = parseInt(@timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_START])
    ePoint = parseInt(@timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_END])
    # スクロール指定範囲外なら反応させない
    if @scrollValue < sPoint || @scrollValue > ePoint
      return
    @scrollValue = if @scrollValue < sPoint then sPoint else @scrollValue
    @scrollValue = if @scrollValue >= ePoint then ePoint - 1 else @scrollValue

    (@constructor.prototype[methodName]).call(@, @scrollValue - sPoint)

    if @scrollValue - sPoint >= @scrollLength() - 1
      @isFinishedEvent = true
      if complete?
        complete()

  # スクロールの長さを取得
  scrollLength: ->
    return parseInt(@timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_END]) - parseInt(@timelineEvent[TimelineEvent.PageValueKey.SCROLL_POINT_START])

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

  removeCss: (methodName) ->
    funcName = "#{methodName}_#{@id}"
    window.cssCode.find(".#{funcName}").remove()

  # ページング時
  clearPaging: (methodName) ->
    @removeCss(methodName)

CommonEventListener =
  # 初期化
  initWithEvent: (timelineEvent) ->

ItemEventListener =
  # 初期化
  initWithEvent: (timelineEvent) ->
    @setMiniumObject(timelineEvent[TLEItemChange.minObj])

    # アイテムを描画
    # TODO: 設定で初期表示させるか切り替えさせる

  # 最小限のデータを設定
  # @abstract
  setMiniumObject: (obj) ->