# イベントリスナー Extend
class EventBase extends Extend

  # イベントの初期化
  # @param [Object] event 設定イベント
  initEvent: (event) ->
    @event = event
    @isFinishedEvent = false
    @doPreviewLoop = false
    @enabledDirections = @event[EventPageValueBase.PageValueKey.SCROLL_ENABLED_DIRECTIONS]
    @forwardDirections = @event[EventPageValueBase.PageValueKey.SCROLL_FORWARD_DIRECTIONS]

    # アクションメソッドの設定
    if !@constructor.prototype[@getEventMethodName()]?
      # メソッドが見つからない場合は終了
      return
    # スクロールイベント
    if @getEventActionType() == Constant.ActionEventHandleType.SCROLL
      @scrollEvent = @scrollRootFunc
    # クリックイベント
    else if @getEventActionType() == Constant.ActionEventHandleType.CLICK
      @clickEvent = @clickRootFunc

  # 設定されているイベントメソッド名を取得
  # @return [String] メソッド名
  getEventMethodName: ->
    if @event?
      return @event[EventPageValueBase.PageValueKey.METHODNAME]

  # 設定されているイベントアクションタイプを取得
  # @return [Integer] アクションタイプ
  getEventActionType: ->
    if @event?
      return @event[EventPageValueBase.PageValueKey.ACTIONTYPE]

  # 設定されているフォーク番号を取得
  # @return [Integer] フォーク番号
  getForkNum: ->
    if @event?
      num = @event[EventPageValueBase.PageValueKey.FORKNUM]
      if num?
        return parseInt(num)
      else
        # forkNumが無い場合はMasterとする
        PageValue.Key.EF_MASTER_FORKNUM
    else
      PageValue.Key.EF_MASTER_FORKNUM

  # リセット(アクション前に戻す)
  resetEvent: ->
    @updateEventBefore()
    @isFinishedEvent = false

  # アクション実行後にする
  forwardEvent: ->
    @updateEventAfter()

  # プレビュー開始
  # @param [Object] event 設定イベント
  preview: (event) ->
    _preview = (event) ->
      drawDelay = 30 # 0.03秒毎スクロール描画
      loopDelay = 1000 # 1秒毎イベント実行
      loopMaxCount = 5 # ループ5回

      # イベント初期化
      @initEvent(event)
      @willChapter()
      if @ instanceof CssItemBase
        @appendCssIfNeeded()

      method = @constructor.prototype[@getEventMethodName()]
      actionType = @getEventActionType()
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

    @stopPreview( =>
      window.runningPreview = true
      _preview.call(@, event)
    )

  # プレビューを停止
  # @param [Function] callback コールバック
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
  willChapter: ->
    actionType = @getEventActionType()
    if actionType == Constant.ActionEventHandleType.SCROLL
      @scrollValue = 0

    # 状態をイベント前に戻す
    @updateEventBefore()

  # チャプター終了時イベント
  # @abstract
  didChapter: ->

  # スクロール基底メソッド
  # @param [Integer] x スクロール横座標
  # @param [Integer] y スクロール縦座標
  # @param [Function] complete イベント終了後コールバック
  scrollRootFunc: (x, y, complete = null) ->
    methodName = @getEventMethodName()
    if !methodName?
      # メソッドが無い場合
      return

    if @isFinishedEvent
      # 終了済みの場合
      return

    # 動作済みフラグON
    if window.eventAction?
      window.eventAction.thisPage().thisChapter().doMoveChapter = true

    # スクロール値更新
    #console.log("y:#{y}")
    plusX = 0
    plusY = 0
    if x > 0 && @enabledDirections.right
      plusX = parseInt((x + 9) / 10)
    else if x < 0 && @enabledDirections.left
      plusX = parseInt((x - 9) / 10)
    if y > 0 && @enabledDirections.bottom
      plusY = parseInt((y + 9) / 10)
    else if y < 0 && @enabledDirections.top
      plusY = parseInt((y - 9) / 10)

    if (plusX > 0 && !@forwardDirections.right) ||
      (plusX < 0 && @forwardDirections.left)
        plusX = -plusX
    if (plusY > 0 && !@forwardDirections.bottom) ||
      (plusY < 0 && @forwardDirections.top)
        plusY = -plusY

    @scrollValue += plusX + plusY

    sPoint = parseInt(@event[EventPageValueBase.PageValueKey.SCROLL_POINT_START])
    ePoint = parseInt(@event[EventPageValueBase.PageValueKey.SCROLL_POINT_END])

    # スクロール指定範囲外なら反応させない
    if @scrollValue < sPoint
      @scrollValue = sPoint
      return
    else if @scrollValue >= ePoint
      @scrollValue = ePoint
      if !@isFinishedEvent
        # 終了イベント
        @isFinishedEvent = true
        ScrollGuide.hideGuide()
        if complete?
          complete()
      return

    @canForward = @scrollValue < ePoint
    @canReverse = @scrollValue > sPoint

    (@constructor.prototype[methodName]).call(@, @scrollValue - sPoint)

  # スクロールの長さを取得
  # @return [Integer] スクロール長さ
  scrollLength: ->
    return parseInt(@event[EventPageValueBase.PageValueKey.SCROLL_POINT_END]) - parseInt(@event[EventPageValueBase.PageValueKey.SCROLL_POINT_START])

  # スクロール基底メソッド
  # @param [Object] e クリックオブジェクト
  # @param [Function] complete イベント終了後コールバック
  clickRootFunc: (e, complete = null) ->
    e.preventDefault()
    # 動作済みフラグON
    if window.eventAction?
      window.eventAction.thisPage().thisChapter().doMoveChapter = true
    (@constructor.prototype[@getEventMethodName()]).call(@, e, complete)

  # イベント後の表示状態にする
  # @abstract
  updateEventAfter: ->

  # イベント前の表示状態にする
  # @abstract
  updateEventBefore: ->

  # アイテムの情報をページ値に保存
  # @property [Boolean] isCache キャッシュとして保存するか
  setItemAllPropToPageValue: (isCache = false)->
    prefix_key = if isCache then PageValue.Key.instanceValueCache(@id) else PageValue.Key.instanceValue(@id)
    obj = @getMinimumObject()
    PageValue.setInstancePageValue(prefix_key, obj)

class CommonEventBase extends EventBase
  # イベントの初期化
  # @param [Object] event 設定イベント
  initEvent: (event) ->
    super(event)

class ItemEventBase extends EventBase
  # イベントの初期化
  # @param [Object] event 設定イベント
  initEvent: (event) ->
    super(event)
    # インスタンス値設定
    objId = event[EventPageValueBase.PageValueKey.ID]
    instance = PageValue.getInstancePageValue(PageValue.Key.instanceValue(objId))
    @setMiniumObject(instance)
    # 描画してアイテムを作成
    # 表示非表示はwillChapterで切り替え
    @reDraw(false)

  # 最小限のデータを設定
  # @abstract
  setMiniumObject: (obj) ->
