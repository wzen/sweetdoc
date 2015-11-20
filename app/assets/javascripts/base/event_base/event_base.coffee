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
    if @getEventActionType() == Constant.ActionType.SCROLL
      @scrollEvent = @scrollHandlerFunc
    # クリックイベント
    else if @getEventActionType() == Constant.ActionType.CLICK
      @clickEvent = @clickHandlerFunc

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

  # 変更設定されているフォーク番号を取得
  # @return [Integer] フォーク番号
  getChangeForkNum: ->
    if @event?
      num = @event[EventPageValueBase.PageValueKey.CHANGE_FORKNUM]
      if num?
        return parseInt(num)
      else
        # forkNumが無い場合はNULL
        return null
    else
      return null

  # リセット(アクション前に戻す)
  resetEvent: ->
    @updateEventBefore()
    @isFinishedEvent = false

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
        @appendAnimationCssIfNeeded()

      actionType = @getEventActionType()
      # イベントループ
      @doPreviewLoop = true
      loopCount = 0
      @previewTimer = null
      # FloatView表示
      FloatView.show(FloatView.displayPositionMessage(), FloatView.Type.PREVIEW)
      if actionType == Constant.ActionType.SCROLL
        p = 0
        _draw = =>
          if @doPreviewLoop
            if @previewTimer?
              clearTimeout(@previewTimer)
              @previewTimer = null
            @previewTimer = setTimeout( =>
              @execMethod(p)
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

      else if actionType == Constant.ActionType.CLICK
        _loop = =>
          if @doPreviewLoop
            loopCount += 1
            if loopCount >= loopMaxCount
              @stopPreview()

            if @previewTimer?
              clearTimeout(@previewTimer)
              @previewTimer = null
            @previewTimer = setTimeout( =>
              @execMethod(null, _loop)
            , loopDelay)
          else
            if @previewFinished?
              @previewFinished()
              @previewFinished = null

        @execMethod(null, _loop)

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
        FloatView.hide()
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
      window.eventAction.thisPage().progressChapter()

  # チャプター開始前イベント
  willChapter: ->
    actionType = @getEventActionType()
    if actionType == Constant.ActionType.SCROLL
      @scrollValue = 0
    # インスタンスの状態を保存
    PageValue.saveInstanceObjectToFootprint(@id, true, @event[EventPageValueBase.PageValueKey.DIST_ID])
    # 状態をイベント前に戻す
    @updateEventBefore()

  # チャプター終了時イベント
  didChapter: ->
    # インスタンスの状態を保存
    PageValue.saveInstanceObjectToFootprint(@id, false, @event[EventPageValueBase.PageValueKey.DIST_ID])

  # メソッド実行
  execMethod: (params, complete = null) ->
    methodName = @getEventMethodName()
    if !methodName?
      # メソッドが無い場合
      return

    # メソッド共通処理
    actionType =  Common.getActionTypeByCodingActionType(@constructor.actionProperties.methods[methodName].actionType)
    if actionType == Constant.ActionType.SCROLL
      # アイテム位置&サイズ更新
      @updateInstanceParamByScroll(params)
    else if actionType == Constant.ActionType.CLICK
      setTimeout( =>
        @updateInstanceParamByClick()
      , 0)

    (@constructor.prototype[methodName]).call(@, params, complete)

  # スクロール基底メソッド
  # @param [Integer] x スクロール横座標
  # @param [Integer] y スクロール縦座標
  # @param [Function] complete イベント終了後コールバック
  scrollHandlerFunc: (x, y, complete = null) ->
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

    @execMethod(@scrollValue - sPoint)

  # スクロールの長さを取得
  # @return [Integer] スクロール長さ
  scrollLength: ->
    return parseInt(@event[EventPageValueBase.PageValueKey.SCROLL_POINT_END]) - parseInt(@event[EventPageValueBase.PageValueKey.SCROLL_POINT_START])

  # スクロール基底メソッド
  # @param [Object] e クリックオブジェクト
  # @param [Function] complete イベント終了後コールバック
  clickHandlerFunc: (e, complete = null) ->
    e.preventDefault()
    # 動作済みフラグON
    if window.eventAction?
      window.eventAction.thisPage().thisChapter().doMoveChapter = true
    @execMethod(e, complete)

  # イベント前のインスタンスオブジェクトを取得
  getMinimumObjectEventBefore: ->
    diff = PageValue.getFootprintPageValue(PageValue.Key.footprintInstanceDiffBefore(@event[EventPageValueBase.PageValueKey.DIST_ID], @id))
    obj = PageValue.getInstancePageValue(PageValue.Key.instanceValue(@id))
    return $.extend(true, obj, diff)

  # イベント前の表示状態にする
  updateEventBefore: ->
    @setMiniumObject(@getMinimumObjectEventBefore())

  # イベント後の表示状態にする
  updateEventAfter: ->
    actionType =  Common.getActionTypeByCodingActionType(@constructor.actionProperties.methods[@getEventMethodName()].actionType)
    if actionType == Constant.ActionType.SCROLL
      @updateInstanceParamByScroll(null, true)
    else if actionType == Constant.ActionType.CLICK
      @updateInstanceParamByClick(true)
    # インスタンスの状態を保存
    PageValue.saveInstanceObjectToFootprint(@id, false, @event[EventPageValueBase.PageValueKey.DIST_ID])

  # スクロールによるアイテム状態更新
  updateInstanceParamByScroll: (scrollValue, immediate = false)->
    # TODO: varAutoChange=falseの場合は(変数)_xxxの形で変更前、変更後、進捗を渡してdraw側で処理させる
    progressPercentage = scrollValue / @scrollLength()
    eventBeforeObj = @getMinimumObjectEventBefore()
    mod = @constructor.actionProperties.methods[@getEventMethodName()].modifiables
    for varName, value of mod
      before = eventBeforeObj[varName]
      after = @event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName]
      if before? && after?
        if immediate
          this[varName] = after
        else
          if value.varAutoChange
            if value.type == Constant.ItemDesignOptionType.NUMBER
              this[varName] = before + (after - before) * progressPercentage
            else if value.type == Constant.ItemDesignOptionType.COLOR
              colorCacheVarName = "#{varName}ColorChangeCache"
              if !this[colorCacheVarName]?
                this[colorCacheVarName] = Common.colorChangeCacheData(before, after, @scrollLength())
              this[varName] = this[colorCacheVarName][scrollValue]

  # クリックによるアイテム状態更新
  updateInstanceParamByClick: (immediate = false) ->
    # TODO: varAutoChange=falseの場合は(変数)_xxxの形で変更前、変更後、進捗を渡してdraw側で処理させる
    clickAnimationDuration = @constructor.actionProperties.methods[@getEventMethodName()].clickAnimationDuration
    duration = 0.01
    loopMax = Math.ceil(clickAnimationDuration/ duration)
    eventBeforeObj = @getMinimumObjectEventBefore()
    mod = @constructor.actionProperties.methods[@getEventMethodName()].modifiables

    if immediate
      for varName, value of mod
        after = @event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName]
        if after?
          this[varName] = after
      return

    count = 1
    timer = setInterval( =>
      progressPercentage = duration * count / clickAnimationDuration
      for varName, value of mod
        before = eventBeforeObj[varName]
        after = @event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName]
        if before? && after?
          if value.varAutoChange
            if value.type == Constant.ItemDesignOptionType.NUMBER
              this[varName] = before + (after - before) * progressPercentage
            else if value.type == Constant.ItemDesignOptionType.COLOR
              colorCacheVarName = "#{varName}ColorChangeCache"
              if !this[colorCacheVarName]?
                this[colorCacheVarName] = Common.colorChangeCacheData(before, after, loopMax)
              this[varName] = this[colorCacheVarName][count]
      if count >= loopMax
        clearInterval(timer)
        for varName, value of mod
          after = @event[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName]
          if after?
            this[varName] = after
      count += 1
    , duration * 1000)

  # アイテムの情報をページ値に保存
  # @property [Boolean] isCache キャッシュとして保存するか
  setItemAllPropToPageValue: (isCache = false)->
    prefix_key = if isCache then PageValue.Key.instanceValueCache(@id) else PageValue.Key.instanceValue(@id)
    obj = @getMinimumObject()
    PageValue.setInstancePageValue(prefix_key, obj)
